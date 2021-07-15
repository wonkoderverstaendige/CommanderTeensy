import argparse

import numpy as np
import pyglet
import sounddevice as sd
from pyglet import shapes
from pyglet.window import key
import zmq
import random
import time
import datetime


def play_sinewave(frequency, duration):
    volume = 0.5
    fs = 44100
    samples = (np.sin(2 * np.pi * np.arange(fs * duration) * frequency / fs)).astype(np.float32)
    sd.play(samples, fs)


class HabituationGame(pyglet.window.Window):
    def __init__(self, fullscreen=False, resizable=True, vsync=True, buffered=True, screen_id=0):
        self._display = pyglet.canvas.Display()
        self._screen = self.display.get_screens()[screen_id]
        # self.sw = self.screen.width
        # self.sh = self.screen.height
        self.sw = 600
        self.sh = 480
        config = pyglet.gl.Config(double_buffer=buffered)
        pyglet.options['vsync'] = vsync

        super(HabituationGame, self).__init__(self.sw, self.sh, config=config, vsync=True, fullscreen=fullscreen,
                                         resizable=resizable)

        self.px_scale = 2.0
        # gl.glScalef(self.px_scale, self.px_scale, self.px_scale)

        self.batch = pyglet.graphics.Batch()
        self.keyboard = key.KeyStateHandler()

        self.block_size = self.sw // 35
        self.x = (random.randint(0, self.sw) - self.block_size)
        self.y = (self.sh - self.block_size) // 2
        self.velocity = 5
        self.changeColor = True
        
        self.azimuth = [int(self.sw/2-self.block_size/2 - self.sw*0.35), int(self.sw/2-self.block_size/2 + self.sw*0.35)]
        self.start = datetime.datetime.now()
        delay = random.gauss(10, 2)
        self.centerrect = self.start + datetime.timedelta(seconds=delay)
        self.reward = self.centerrect + datetime.timedelta(seconds=1)
        self.restart = self.reward + datetime.timedelta(seconds=1)

        self.rectangle = shapes.Rectangle(self.x, self.y, self.block_size, self.block_size,
                                          color=(255, 255, 255), batch=self.batch)
        self.controlrect = shapes.Rectangle(self.sw - self.block_size, self.sh - self.block_size, self.block_size,
                                            self.block_size, color=(255, 255, 255), batch=self.batch)

        self.fps_display = pyglet.window.FPSDisplay(window=self)
        pyglet.clock.schedule_interval(self.update, 1 / 60.0)

        pyglet.app.run()

    def update(self, dt):
        if (datetime.datetime.now() > self.centerrect):
            self.rectangle.x = int(self.sw/2 - self.block_size/2)
            self.x = self.rectangle.x
        if (datetime.datetime.now() > self.reward):
            self.rectangle.opacity = 0
        if (datetime.datetime.now() > self.restart):
            self.resettrial()

        
    def resettrial(self):
        self.start = datetime.datetime.now()
        delay = random.gauss(10, 2)
        self.centerrect = self.start + datetime.timedelta(seconds=delay)
        self.reward = self.centerrect + datetime.timedelta(seconds=1)
        self.restart = self.reward + datetime.timedelta(seconds=1)
        self.rectangle.opacity = 255
        self.x = random.choice(self.azimuth)

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
        elif motion == key.MOTION_BEGINNING_OF_LINE:
            self.x = 0
        elif motion == key.MOTION_END_OF_LINE:
            self.x = self.sw - self.block_size

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

    game = HabituationGame(screen_id=cli_args.screen)

