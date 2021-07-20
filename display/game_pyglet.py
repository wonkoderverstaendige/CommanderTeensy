import argparse

import numpy as np
import pyglet
import sounddevice as sd
import logging
from pyglet import shapes
from pyglet.window import key
import zmq
import importlib

from commander_teensy.TeensyCommander import ZMQ_SERVER_PUB_PORT as ZMQ_CLIENT_SUB_PORT
from commander_teensy.TeensyCommander import ZMQ_SERVER_SUB_PORT as ZMQ_CLIENT_PUB_PORT

TEENSY_STATE_VARIABLE_IDX = 7


class PygletGame(pyglet.window.Window):
    def __init__(self, fullscreen=False, resizable=True, vsync=True, buffered=True, screen_id=0, frame_indicator=False,
                 experiment_module=None, sound_volume=0.5):
        self._display = pyglet.canvas.Display()
        self._screen = self.display.get_screens()[screen_id]
        self.sw = self.screen.width
        self.sh = self.screen.height

        config = pyglet.gl.Config(double_buffer=buffered)
        pyglet.options['vsync'] = vsync

        super(PygletGame, self).__init__(self.sw, self.sh, config=config, vsync=True, fullscreen=fullscreen,
                                         resizable=resizable)

        self.px_scale = 2.0
        # gl.glScalef(self.px_scale, self.px_scale, self.px_scale)

        self.batch = pyglet.graphics.Batch()
        self.keyboard = key.KeyStateHandler()

        self.block_size = self.sw // 15
        self.screen_x_zero = (self.sw - self.block_size) // 2
        self.screen_y_zero = (self.sh - self.block_size) // 2

        self.cursor = shapes.Rectangle(self.screen_x_zero, self.screen_y_zero, self.block_size, self.block_size,
                                       color=(255, 255, 255), batch=self.batch)

        self.target = shapes.Rectangle(self.screen_x_zero, self.screen_y_zero, self.block_size/4, self.block_size/4,
                                       color=(255, 255, 255), batch=self.batch)

        self.frame_indicator_state = True
        self.frame_indicator_colors = {True: (0, 0, 0), False: (255, 255, 255)}
        self.frame_indicator = None if not frame_indicator else shapes.Rectangle(self.sw - self.block_size,
                                                                                 self.sh - self.block_size,
                                                                                 self.block_size,
                                                                                 self.block_size, color=(255, 255, 255),
                                                                                 batch=self.batch)

        self.fps_display = pyglet.window.FPSDisplay(window=self)
        pyglet.clock.schedule_interval(self.update, 1 / 60.0)

        self.zmq_ctx = zmq.Context()
        self.zmq_sub = self.zmq_ctx.socket(zmq.SUB)
        self.zmq_sub.setsockopt_string(zmq.SUBSCRIBE, "")
        self.zmq_sub.connect(f"tcp://127.0.0.1:{ZMQ_CLIENT_SUB_PORT}")

        self.zmq_pub = self.zmq_ctx.socket(zmq.PUB)
        self.zmq_pub.connect(f"tcp://127.0.0.1:{ZMQ_CLIENT_PUB_PORT}")

        self.audio_fs = 44100
        # global "maximum" volume
        self.audio_volume = sound_volume

        self.experiment = None
        if experiment_module:
            logging.info(f'Loading module {experiment_module}')
            experiment_module = importlib.import_module('.' + experiment_module, 'experiments')
            self.experiment = experiment_module.Experiment(self)

        logging.debug('Starting engine...')
        pyglet.app.run()

    def update(self, dt):
        # TODO: State updates should take all received packets into account
        messages = []
        while True:
            try:
                msg = self.zmq_sub.recv_pyobj(zmq.DONTWAIT)
                messages.append(msg)
            except zmq.Again:
                break
        self.experiment.update(messages)

    def send(self, instruction):
        self.zmq_pub.send_pyobj(instruction)

    def on_key_press(self, symbol, modifiers):
        if symbol in [key.RETURN, key.ESCAPE, key.Q]:
            if self.experiment:
                self.experiment.end()
            self.exit()
        else:
            if self.experiment:
                self.experiment.user_input(symbol, modifiers)

    def on_text_motion(self, motion):
        if self.experiment:
            self.experiment.user_input_motion(motion)

    def on_draw(self):
        self.clear()
        if self.experiment:
            self.cursor.x = (self.experiment.x + 1) / 2 * self.sw - self.cursor.width / 2
            self.cursor.y = (self.experiment.y + 1) / 2 * self.sh - self.cursor.height / 2

            if self.experiment.current_goal is not None:
                self.target.x = (self.experiment.current_goal + 1) / 2 * self.sw - self.target.width / 2
                self.target.y = (0 + 1) / 2 * self.sh - self.target.height / 2

            self.cursor.visible = self.experiment.cue_visible
            self.target.visible = self.experiment.trial_active

        if self.frame_indicator:
            self.frame_indicator.color = self.frame_indicator_colors[self.frame_indicator_state]
            self.frame_indicator_state = not self.frame_indicator_state

        self.batch.draw()
        self.fps_display.draw()

    def play_sine(self, frequency, duration, volume=1.0):
        """SoundDevice requires available sound sink, i.e. active headphone jack detection."""
        n_samples = int(self.audio_fs * duration / 1000)
        samples = np.sin(2 * np.pi * np.arange(n_samples) * frequency / self.audio_fs).astype(
            np.float32) * self.audio_volume * volume
        try:
            sd.play(samples, self.audio_fs)
        except sd.PortAudioError as e:
            logging.error(f'Failed to play audio: {e}')

    def exit(self):
        # logging.info(f'{self.n_trials} with {self.n_success}')
        self.close()
        pyglet.app.exit()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--screen', type=int, default=0)
    parser.add_argument('-e', '--experiment', type=str, help="Name of experiments module in ../experiments/")
    parser.add_argument('-I', '--indicator', action='store_true', help='Show frame update indicator')
    parser.add_argument('-F', '--fullscreen', action='store_true', help='Show frame update indicator')
    parser.add_argument('-V', '--volume', type=float, help='Global maximum audio volume', default=0.5)
    parser.add_argument('-v', '--verbose', action='count', default=0, help="Increase logging verbosity")
    cli_args = parser.parse_args()

    try:
        loglevel = {
            0: logging.ERROR,
            1: logging.WARN,
            2: logging.INFO,
        }[cli_args.verbose]
    except KeyError:
        loglevel = logging.DEBUG

    print(loglevel)
    log_format = '[%(asctime)s]{%(filename)s:%(lineno)d} %(levelname)s - %(message)s'
    logging.basicConfig(level=loglevel,
                        format=log_format,
                        datefmt='%H:%M:%S',
                        force=True)

    logging.warning('test')

    game = PygletGame(screen_id=cli_args.screen, fullscreen=cli_args.fullscreen, experiment_module=cli_args.experiment,
                      frame_indicator=cli_args.indicator, sound_volume=cli_args.volume)
