from commander_teensy.display.Experiment import ExperimentSkeleton
import logging
import random
import time
import math
from pyglet.window import key
from collections import deque

WHEEL_AMPLIFICATION = 1  # amplifying wheel displacement
TRANSLATION_FACTOR = 1 / 63 * WHEEL_AMPLIFICATION

MAX_TRIAL_DURATION = 60  # Maximum trial length in seconds
MAX_OVERSHOOT = 1.1  # allowed movement in wrong direction
MAX_HOLD_MOVEMENT = 1 / 6  # allowed movement during "holding" timeout
MAX_TRIAL_NUMBER = 400  # maximum trials allowed for session

START_POS_OFFSET = 0.63

START_DELAY_MIN = 0.2  # delay of trial onset
START_DELAY_MAX = 0.5

WHEEL_STATE_IDX = 0  # packet.states index of wheel encoder position

CURSOR_SIZE = 1 / 8  # fraction of screen width

GOAL_PROXIMITY = 0.05


class Experiment(ExperimentSkeleton):
    def __init__(self, *args, **kwargs):
        super(Experiment, self).__init__(*args, **kwargs)
        self.target_visible = False
        self.n_trial = 0
        self.n_success = 0
        self.n_failure = 0
        self.debiasing_len_history = 10

        self.x = 0
        self.y = 0.1
        self.x_zero = 0
        self.starting_position = 0
        self.last_wheel_position = 0
        self.directions_trial_moves = deque(maxlen=self.debiasing_len_history)

        self.start_delay = 0

        self.t_start_trial = None
        self.t_timeout_end = None
        self.t_holdout_end = None

        self.reward_given = False
        self.repeat_trial = False  # indicate the trial should be repeated, i.e. soft de-biasing applied

        self.timeout_failure = False

        self.current_state = None
        self.next_state = None

        self.trial_result = None

    def start(self):
        self.frontend.send({'instruction': 'reset', 'data': []})
        self.start_trial()

    def start_trial(self):
        self.frontend.cursor.visible = False
        self.trial_result = None
        self.t_start_trial = time.time()

        self.n_trial += 1
        if self.repeat_trial and len(self.directions_trial_moves) == self.directions_trial_moves.maxlen:
            # de-biasing should be applied and we have enough past trials to do so
            mu = sum(self.directions_trial_moves) / self.directions_trial_moves.maxlen
        else:
            mu = 0.5
        d = random.normalvariate(mu, sigma=0.5)
        logging.debug(f'Starting trial on {"Left" if d < 0 else "Right"} with d={d:0.2f}')
        logging.debug(self.directions_trial_moves)

        self.starting_position = (int(d < 0.5) * 2 - 1) * START_POS_OFFSET
        self.manual_x = 0
        self.x_zero = -self.last_wheel_position
        self.x = self.x_zero + self.starting_position
        self.frontend.cursor.visible = False

        self.start_delay = random.uniform(START_DELAY_MIN, math.sqrt(START_DELAY_MAX)) ** 2
        logging.info(
            f'Starting trial {self.n_trial} from the {"left" if self.x_zero < 0 else "right"} with '
            f'{self.start_delay:0.1f} s delay')
        self.current_state = None
        self.timeout(self.start_delay, self.state_holdout)

    def timeout(self, duration, next_state):
        self.next_state = next_state
        self.t_timeout_end = time.time() + duration
        self.current_state = self.state_timeout

    def state_timeout(self):
        if time.time() < self.t_timeout_end:
            return
        else:
            self.current_state = self.next_state

    def state_holdout(self):
        self.x = self.x_zero + self.last_wheel_position + self.manual_x
        # wait here for X seconds without turning
        dx = abs(self.x - self.starting_position)
        if dx > MAX_HOLD_MOVEMENT:
            logging.info(f'Hold movement exceeded. Timeout for {self.start_delay:0.2f}s')
            self.x_zero = -self.last_wheel_position + self.starting_position
            self.x = self.x_zero + self.last_wheel_position + self.starting_position
            self.timeout(self.start_delay, self.state_holdout)
            return

        # else move into interactive mode
        if time.time() >= self.t_timeout_end:
            self.manual_x = 0
            self.x_zero = -self.last_wheel_position + self.starting_position
            self.x = self.x_zero
            self.frontend.play_sine(5000, 100, volume=0.5)
            self.current_state = self.state_steering
            self.frontend.cursor.visible = True

    def state_steering(self):
        self.x = self.x_zero + self.last_wheel_position + self.manual_x

        # check if trial duration was exceeded
        t_elapsed = time.time() - self.t_start_trial
        if t_elapsed > MAX_TRIAL_DURATION:
            # self.x = self.starting_position
            self.end_trial(False, result=('timeout', t_elapsed))

        # check if subject steered too far in wrong direction
        if abs(self.x) > MAX_OVERSHOOT:
            self.end_trial(False, result=('overshoot', t_elapsed))

        # check if reached target position (center)
        if (self.starting_position > 0 >= self.x) or (self.starting_position < 0 <= self.x):
            self.end_trial(True, ('goal', t_elapsed))

    def update_states(self):
        if self.last_packets:
            self.last_wheel_position = -self.last_packets[-1].states[WHEEL_STATE_IDX] * TRANSLATION_FACTOR

        # move with key press
        # TODO: This seems to be behaving differently on the raspi
        # if self.frontend.pressed_keys[key.LEFT]:
        #     self.manual_x -= self.manual_velocity
        # elif self.frontend.pressed_keys[key.RIGHT]:
        #     self.manual_x += self.manual_velocity

        if self.current_state:
            self.current_state()

        x = int(max(min(self.x * 2048, 4096), -4096))
        y = int(max(min(self.y * 2048, 4096), -4096))
        v = int(self.frontend.cursor.visible * 1000)
        self.frontend.send({'instruction': 'state',
                            'data': [(1, x), (2, y), (3, v), (4, self.n_trial), (5, self.n_success)]})

    def end_trial(self, success, result=None):
        # state transitions should be communicated to teensy
        direction = self.x_zero > self.x
        logging.info(
            f'Ending trial {self.n_trial} with {"success" if success else "failure"} due to "{result[0]}" '
            f'after {result[1]:0.1f} s.')

        # store the direction of the wheel over the trial if not a timeout
        if result[0] != 'timeout':
            self.directions_trial_moves.append(direction)

        if success:
            self.n_success += 1
            self.repeat_trial = False
        else:
            self.n_failure += 1
            if not result[0] == 'timeout':
                self.repeat_trial = True

        total = self.n_success + self.n_failure
        logging.info(
            f'Total: {self.n_trial}, Successes: {self.n_success} ({self.n_success / total * 100:0.1f}% correct)!')

        if success:
            self.trigger_solenoid(solenoid=1, duration=30)
            self.frontend.cursor.visible = True
            self.x = 0
            self.timeout(1.5, self.start_trial)
        else:
            self.frontend.cursor.visible = False
            self.frontend.play_whitenoise(500)
            self.x = 0.9 if self.starting_position > 0 else -0.9
            self.timeout(2, self.start_trial)
