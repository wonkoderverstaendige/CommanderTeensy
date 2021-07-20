import math
import time

from pyglet.window import key


class ExperimentSkeleton:
    def __init__(self, frontend):
        self.frontend = frontend
        self.trial_active = False
        self.x_zero = 0
        self.y_zero = 0
        self.x = 0
        self.y = 0
        self.manual_velocity = 0.01
        self.cue_visible = False

    def user_input(self, symbol, modifiers):
        if symbol in [key.S]:
            self.start_trial(goal=None)
        elif symbol in [key.E]:
            self.end_trial(result=None)
        self.update(None)

    def user_input_motion(self, motion):
        if motion == key.MOTION_LEFT:
            self.x -= self.manual_velocity
        elif motion == key.MOTION_RIGHT:
            self.x += self.manual_velocity
        elif motion == key.MOTION_BACKSPACE:
            self.x = 0
        elif motion == key.MOTION_BEGINNING_OF_LINE:
            self.x = -1
        elif motion == key.MOTION_END_OF_LINE:
            self.x = 1
        self.update(None)

    def update(self, packets):
        if self.trial_active:
            self.x = math.sin(time.time())
        else:
            pass

    def start(self):
        pass

    def start_trial(self, goal=None):
        self.trial_active = True

    def end_trial(self, success, result=None):
        self.trial_active = False

    def end(self):
        self.frontend.exit()
