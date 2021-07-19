import argparse

import numpy as np
import pyglet
import sounddevice as sd
import logging
from pyglet import shapes
from pyglet.window import key
import zmq
from pathlib import Path
import importlib

from commander_teensy.TeensyCommander import ZMQ_SERVER_PUB_PORT as ZMQ_CLIENT_SUB_PORT
from commander_teensy.TeensyCommander import ZMQ_SERVER_SUB_PORT as ZMQ_CLIENT_PUB_PORT

TEENSY_STATE_VARIABLE_IDX = 7


class PygletGame(pyglet.window.Window):
    def __init__(self, fullscreen=False, resizable=True, vsync=True, buffered=True, screen_id=0, frame_indicator=False,
                 experiment_path=None):
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
        self.x = (self.sw - self.block_size) // 2
        self.y = (self.sh - self.block_size) // 2
        self.velocity = 5

        self.rectangle = shapes.Rectangle(self.x, self.y, self.block_size, self.block_size,
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
        self.audio_volume = 0.5

        self.experiment = None
        if experiment_path:
            logging.info(f'Loading module {experiment_path}')
            experiment_module = importlib.import_module(experiment_path.stem)
            self.experiment = experiment_module.Experiment()

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
        if messages:
            # Using last state variable to update the square position
            self.x = (messages[-1].states[7] / 2 ** 16 + 0.5) * self.sw

    def on_key_press(self, symbol, modifiers):
        if symbol in [key.RETURN, key.ESCAPE, key.Q]:
            self.exit()
        elif symbol in [key.S] and self.experiment:
            self.experiment.end_trial()
        elif symbol in [key.A] and self.experiment:
            self.experiment.trial_active = True

    def on_text_motion(self, motion):
        if motion == key.MOTION_LEFT:
            self.x -= self.velocity
        elif motion == key.MOTION_RIGHT:
            self.x += self.velocity
        elif motion == key.MOTION_BACKSPACE:
            self.x = (self.sw - self.block_size) // 2
        elif motion == key.MOTION_BEGINNING_OF_LINE:
            self.x = 0
        elif motion == key.MOTION_END_OF_LINE:
            self.x = self.sw - self.block_size

    def on_draw(self):
        self.clear()
        self.rectangle.x = self.experiment.x if self.experiment else self.x

        if self.frame_indicator:
            self.frame_indicator.color = self.frame_indicator_colors[self.frame_indicator_state]
            self.frame_indicator_state = not self.frame_indicator_state

        self.batch.draw()
        self.fps_display.draw()

    def play_sine(self, frequency, duration, volume=1.0):
        """SoundDevice requires available sound sink, i.e. active headphone jack detection."""
        n_samples = self.audio_fs * duration
        samples = np.sin(2 * np.pi * np.arange(n_samples) * frequency / self.audio_fs).astype(
            np.float32) * self.audio_volume * volume
        try:
            sd.play(samples, self.audio_fs)
        except sd.PortAudioError as e:
            logging.error(f'Failed to play audio: {e}')

    def exit(self):
        self.close()
        pyglet.app.exit()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--screen', type=int, default=0)
    parser.add_argument('-e', '--experiment', type=str)
    cli_args = parser.parse_args()

    if cli_args.experiment:
        cli_args.experiment = Path(cli_args.experiment)
        if not cli_args.experiment.exists():
            raise FileNotFoundError(f'File {cli_args.experiment} not found.')

    game = PygletGame(screen_id=cli_args.screen, experiment_path=cli_args.experiment)
