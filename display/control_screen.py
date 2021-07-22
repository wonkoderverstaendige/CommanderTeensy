import argparse

import numpy as np
import pyglet

from pyglet import shapes
from pyglet.window import key
import zmq
import importlib

from commander_teensy.TeensyCommander import ZMQ_SERVER_PUB_PORT as ZMQ_CLIENT_SUB_PORT

class ControlScreen(pyglet.window.Window):
    def __init__(self, fullscreen=False, resizable=True, vsync=True, buffered=True, screen_id=0):
        self._display = pyglet.canvas.Display()
        self._screen = self.display.get_screens()[screen_id]
        self.sw = self.screen.width
        self.sh = self.screen.height

        config = pyglet.gl.Config(double_buffer=buffered)
        pyglet.options['vsync'] = vsync

        super(ControlScreen, self).__init__(self.sw, self.sh, config=config, vsync=True, fullscreen=fullscreen,
                                         resizable=resizable)

        self.px_scale = 2.0
        
        self.batch = pyglet.graphics.Batch()
        self.keyboard = key.KeyStateHandler()

        self.block_size = self.sw // 15
        self.screen_x_zero = (self.sw - self.block_size) // 2
        self.screen_y_zero = (self.sh - self.block_size) // 2

        self.cursor = shapes.Rectangle(self.screen_x_zero, self.screen_y_zero, self.block_size, self.block_size,
                                       color=(255, 255, 255), batch=self.batch)

        self.target = shapes.Rectangle(self.screen_x_zero, self.screen_y_zero, self.block_size / 4, self.block_size / 4,
                                       color=(255, 255, 255), batch=self.batch)
        

        self.zmq_ctx = zmq.Context()
        self.zmq_sub = self.zmq_ctx.socket(zmq.SUB)
        self.zmq_sub.setsockopt_string(zmq.SUBSCRIBE, "")
        #self.zmq_sub.connect(f"tcp://127.0.0.1:{ZMQ_CLIENT_SUB_PORT}")
        self.zmq_sub.connect(f"tcp://127.0.0.1:9999")
    
        self.x = 0
        self.y = 0
        pyglet.clock.schedule_interval(self.update, 1 / 60.0)
        
        pyglet.app.run()
        
    def update(self, dt):
        try:
            msg = self.zmq_sub.recv_pyobj(zmq.DONTWAIT)
            self.x = msg[0]
            #self.x = msg[0].states[7] / TRANSLATION_FACTOR
            #print(msg)
        except zmq.Again:
            sleep(0.000001)        

    def on_draw(self):
        self.clear()
        self.cursor.x = (self.x + 1) / 2 * self.sw - self.cursor.width / 2
        self.cursor.y = (self.y + 1) / 2 * self.sh - self.cursor.height / 2
        self.batch.draw()
            #if self.experiment.current_goal is not None:
            #self.target.x = (self.current_goal + 1) / 2 * self.sw - self.target.width / 2
            #self.target.y = (0 + 1) / 2 * self.sh - self.target.height / 2

    def exit(self):
        self.close()
        pyglet.app.exit()

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--screen', type=int, default=0)
    parser.add_argument('-F', '--fullscreen', action='store_true', help='Show in fullscreen mode')
    cli_args = parser.parse_args()

    game = ControlScreen(screen_id=cli_args.screen, fullscreen=cli_args.fullscreen)

