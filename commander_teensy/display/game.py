import argparse
import logging
import sys
from pathlib import Path
from datetime import datetime
import multiprocessing

log_format = '[%(asctime)s]{%(filename)s:%(lineno)d} %(levelname)s - %(message)s'
logging.basicConfig(level=logging.DEBUG,
                    format=log_format,
                    datefmt='%H:%M:%S')

import pyglet

from pyglet import shapes
from pyglet.window import key
import zmq
import importlib

from commander_teensy.TeensyCommander import ZMQ_SERVER_PUB_PORT as ZMQ_CLIENT_SUB_PORT
from commander_teensy.TeensyCommander import ZMQ_SERVER_SUB_PORT as ZMQ_CLIENT_PUB_PORT
from commander_teensy.display.Sound import SoundProcess

DEFAULT_MAX_VOLUME = 0.05


class PygletGame(pyglet.window.Window):
    def __init__(self, fullscreen=False, resizable=True, vsync=True, buffered=True, screen_id=0, frame_indicator=False,
                 experiment_path=None, sound_volume=DEFAULT_MAX_VOLUME, sound_device=0):
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

        self.frame_indicator_state = True
        self.frame_indicator_colors = {True: (0, 0, 0), False: (255, 255, 255)}
        indicator_size = self.sw // 25
        self.frame_indicator = None if not frame_indicator else shapes.Rectangle(self.sw - indicator_size,
                                                                                 self.sh - indicator_size,
                                                                                 indicator_size,
                                                                                 indicator_size, color=(255, 255, 255),
                                                                                 batch=self.batch)

        cursor_size = self.sw // 15
        self.cursor = shapes.Rectangle(0, 0, cursor_size, cursor_size, color=(255, 255, 255), batch=self.batch)
        self.cursor.visible = True

        self.fps_display = pyglet.window.FPSDisplay(window=self)
        pyglet.clock.schedule_interval(self.update, 1 / 60.0)

        self.zmq_ctx = zmq.Context()
        self.zmq_sub = self.zmq_ctx.socket(zmq.SUB)
        self.zmq_sub.setsockopt_string(zmq.SUBSCRIBE, "")
        self.zmq_sub.connect(f"tcp://127.0.0.1:{ZMQ_CLIENT_SUB_PORT}")

        self.zmq_pub = self.zmq_ctx.socket(zmq.PUB)
        self.zmq_pub.connect(f"tcp://127.0.0.1:{ZMQ_CLIENT_PUB_PORT}")

        logging.info('Starting engine process...')
        self.sound_queue = multiprocessing.Queue(10)
        self.sound = SoundProcess(queue=self.sound_queue, max_volume=sound_volume, device=sound_device)
        self.sound.start()

        self.experiment = None
        if experiment_path:
            logging.info(f'Loading module {experiment_path}')
            experiment_path = Path(experiment_path).resolve()
            if not experiment_path.exists() or experiment_path.is_dir():
                raise FileNotFoundError(f"Module '{experiment_path}' not found.")

            sys.path.append(str(experiment_path.parent))
            logging.info(f'Adding {experiment_path.parent} to path to import "{experiment_path.stem}"')
            experiment_module = importlib.import_module(experiment_path.stem)
            sys.path.pop()
            self.experiment = experiment_module.Experiment(self)
        else:
            logging.warning(f'No experiment specified! Using base ExperimentSkeleton.')
            from commander_teensy.display.Experiment import ExperimentSkeleton as Experiment
            self.experiment = Experiment(self)

        logging.debug('Starting pyglet app...')
        pyglet.app.run()

    def update(self, dt):
        packets = []
        while True:
            try:
                msg = self.zmq_sub.recv_pyobj(zmq.DONTWAIT)
                packets.append(msg)
            except zmq.Again:
                break
        self.experiment.process_packets(packets)
        self.experiment.update_states()

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

        self.cursor.x = (self.experiment.x + 1) / 2 * self.sw - self.cursor.width / 2
        self.cursor.y = (self.experiment.y + 1) / 2 * self.sh - self.cursor.height / 2

        if self.frame_indicator:
            self.frame_indicator.color = self.frame_indicator_colors[self.frame_indicator_state]
            self.frame_indicator_state = not self.frame_indicator_state

        self.batch.draw()
        self.fps_display.draw()

    def play_sine(self, duration, frequency, volume=1.0):
        self.sound_queue.put(['sine', duration, frequency, volume])

    def play_wn(self, duration, volume=1.0):
        self.sound_queue.put(['wn', duration, volume])

    def exit(self):
        self.close()
        pyglet.app.exit()

    def __del__(self):
        self.sound_queue.put(None)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--screen', type=int, default=0)
    parser.add_argument('-e', '--experiment', type=str, help="Path to experiments file")
    parser.add_argument('-I', '--indicator', action='store_true', help='Show frame update indicator')
    parser.add_argument('-F', '--fullscreen', action='store_true', help='Show frame update indicator')
    parser.add_argument('-S', '--sounddevice', type=int, help='Sound device id')
    parser.add_argument('-V', '--volume', type=float, help='Global maximum audio volume', default=DEFAULT_MAX_VOLUME)
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
    #
    # log_format = '[%(asctime)s]{%(filename)s:%(lineno)d} %(levelname)s - %(message)s'
    # logging.basicConfig(level=loglevel,
    #                     format=log_format,
    #                     datefmt='%H:%M:%S')

    start_time_str = datetime.now().strftime("%Y%m%d-%H%M%S")
    log_file = logging.FileHandler(f'{start_time_str}_game.log', mode='w')
    log_file.setLevel(logging.DEBUG)
    log_file.setFormatter(logging.Formatter(log_format))

    console = logging.StreamHandler()
    console.setFormatter(log_format)
    console.setLevel(loglevel)

    logging.getLogger().handlers.clear()
    logging.getLogger().addHandler(log_file)
    # logging.getLogger().setLevel(loglevel)

    game = PygletGame(screen_id=cli_args.screen, fullscreen=cli_args.fullscreen, experiment_path=cli_args.experiment,
                      frame_indicator=cli_args.indicator, sound_volume=cli_args.volume,
                      sound_device=cli_args.sounddevice)


if __name__ == "__main__":
    main()
