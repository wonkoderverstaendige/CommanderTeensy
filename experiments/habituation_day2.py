from commander_teensy.display.Experiment import ExperimentSkeleton
import logging
import random
import time

TRANSLATION_FACTOR = 2 ** 16  #
MAX_TRIAL_LENGTH = random.gauss(10, 2)
FACTOR_OVERSHOOT = .3  # movement in wrong direction


class Experiment(ExperimentSkeleton):
    def __init__(self, *args, **kwargs):
        super(Experiment, self).__init__(*args, **kwargs)
        self.frontend.play_sine(10000, 100)
        self.target_visible = False
        self.n_trial = 0
        self.n_success = 0
        self.n_failure = 0
        self.current_goal = 0
        self.t_start_trial = None
        self.t_timeout_end = None
        self.reward_given = False
        self.max_t_trial = MAX_TRIAL_LENGTH

    def start_trial(self, goal=0):
        # state transitions should be communicated to teensy
        self.t_start_trial = time.time()

        self.n_trial += 1
        self.x = (random.randint(0, 1) * 2 - 1) * 0.9
        logging.info(f'Starting trial {self.n_trial} from the {"left" if self.x < 0 else "right"}')
        self.trial_active = 2

    def update(self, packets):
        if self.trial_active == 2:
            self.cue_visible = True
            self.reward_given = False
            t_delta = time.time() - self.t_start_trial
            if packets:
                self.x = packets[-1].states[7] / TRANSLATION_FACTOR
            
            if t_delta > self.max_t_trial:
                logging.debug('going to 3')
                self.trial_active = 3

        elif self.trial_active == 3:
            self.x = 0
            if self.t_timeout_end is None:
                self.t_timeout_end = self.timeout(0.5)
            elif self.t_timeout_end < time.time():
                if not self.reward_given:
                    self.trigger_solenoid(1, 30)
                    self.reward_given = True
                    self.t_timeout_end = self.timeout(0.5)
                else:
                    self.t_timeout_end = None
                    self.trial_active = 4
                    logging.debug('going to 4')
            
        elif self.trial_active == 4:
            self.cue_visible = False
            if self.t_timeout_end is None:
                self.t_timeout_end = self.timeout(1)
            elif self.t_timeout_end < time.time():
                self.t_timeout_end = None
                logging.debug('going to 2')
                self.start_trial()

    def end_trial(self, success, result=None):
        # state transitions should be communicated to teensy
        if not self.trial_active:
            return
        logging.info(
            f'Ending trial {self.n_trial} with {"success" if success else "failure"} due to "{result[0]}" after {result[1]:0.1f} s')
        
        if success:
            self.n_success += 1
        else:
            self.n_failure += 1

        if success:
            self.trigger_solenoid()
            self.frontend.play_sine(1000, 200)
        else:
            self.frontend.play_sine(300, 500)
            self.timeout(1)
            
        time.sleep(2)
        self.x = 0
        self.frontend.on_draw()
        self.trial_active = False
        #self.frontend.pause_game(1)
        self.cue_visible = False
        self.timeout(3)
        
    def trigger_solenoid(self, solenoid=0, pulse_duration=25):
        logging.debug('GIVING THE JUICE!')
        self.frontend.send({'instruction': 'pulse', 'pin': solenoid, 'data': [pulse_duration]})

    def timeout(self, duration):
        return time.time() + duration
        