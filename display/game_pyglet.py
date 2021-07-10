import pyglet
from pyglet import shapes, gl
from pyglet.window import key

import numpy as np

import argparse
import logging
import time
import sounddevice as sd


class PygletGame(pyglet.window.Window):
    def __init__(self, fullscreen=False, resizable=True, vsync=True, buffered=True, screen_id=0):
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

        self.block_size = self.sw // 35
        self.x = (self.sw - self.block_size) // 2
        self.y = (self.sh - self.block_size) // 2
        self.velocity = 5
        self.changeColor = True

        self.rectangle = shapes.Rectangle(self.x, self.y, self.block_size, self.block_size,
                                          color=(255, 255, 255), batch=self.batch)
        self.controlrect = shapes.Rectangle(self.sw - self.block_size, self.sh - self.block_size, self.block_size,
                                            self.block_size, color=(255, 255, 255), batch=self.batch)

        self.fps_display = pyglet.window.FPSDisplay(window=self)
        pyglet.clock.schedule_interval(self.update, 1 / 60.0)

        self.play_sinewave(1000, 0.1)
        pyglet.app.run()

    def update(self, dt):
        pass

    def play_sinewave(self, frequency, duration):
        volume = 0.5
        fs = 44100
        samples = (np.sin(2 * np.pi * np.arange(fs * duration) * frequency / fs)).astype(np.float32)
        sd.play(samples, fs)

    def on_key_press(self, symbol, modifiers):
        if symbol in [key.RETURN, key.ESCAPE, key.Q]:
            self.close()
            pyglet.app.exit()

    def on_text_motion(self, motion):
        if motion == key.MOTION_LEFT:
            self.x -= self.velocity
        elif motion == key.MOTION_RIGHT:
            self.x += self.velocity
        elif motion == key.MOTION_BACKSPACE:
            self.x = (self.sw - self.block_size) // 2

    def on_draw(self):
        self.clear()
        self.rectangle.x = self.x

        if self.changeColor:
            self.controlrect.color = (255, 255, 255)
            self.changeColor = False
        else:
            self.controlrect.color = (0, 0, 0)
            self.changeColor = True
        self.batch.draw()
        self.fps_display.draw()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--screen', type=int, default=0)

    cli_args = parser.parse_args()

    game = PygletGame(screen_id=cli_args.screen)


