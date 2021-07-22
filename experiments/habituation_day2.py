from .Experiment import ExperimentSkeleton
import logging
import random
import time

TRANSLATION_FACTOR = 2 ** 16  #
MAX_TRIAL_LENGTH = 5 #random.gauss(10, 2)
FACTOR_OVERSHOOT = .3  # movement in wrong direction


class Experiment(ExperimentSkeleton):
    def __init__(self, *args, **kwargs):
        super(Experiment, self).__init__(*args, **kwargs)
        self.frontend.play_sine(10000, 100)
        self.n_trial = 0
        self.n_success = 0
        self.n_failure = 0
        self.current_goal = 0
        self.t_start_trial = None
        self.t_timeout_end = None
        self.max_t_trial = MAX_TRIAL_LENGTH

    def start_trial(self, goal=0):
        # state transitions should be communicated to teensy
        if self.trial_active:
            self.end_trial(None)

        self.t_start_trial = time.time()
        self.cue_visible = True

        self.n_trial += 1
        logging.info(f'Starting trial {self.n_trial} with goal {self.current_goal}')
        self.trial_active = True
        self.target_visible = False
        self.x = (random.randint(0, 1) * 2 - 1) * 0.9
        

    def update(self, packets):
        if not self.trial_active and self.t_timeout_end and self.t_timeout_end - time.time() < 0:
            logging.debug('trial start after timeout')
            self.t_timeout_end = None
            self.start_trial()

        if self.trial_active and (not self.t_timeout_end or self.t_timeout_end - time.time() < 0):
            t_delta = time.time() - self.t_start_trial
            if packets:
                self.x = packets[-1].states[7] / TRANSLATION_FACTOR

            if t_delta > self.max_t_trial:
                self.x = 0
                self.end_trial(True, result=('goal', t_delta))

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

        #self.cue_visible = False
            
        # Missing: wait 500 milli, solenoid, 500 milli, then cue invisible for 1 sec and restart
        #self.frontend.pause_game(10)

        if success:
            self.trigger_solenoid()
            self.frontend.play_sine(1000, 200)
        else:
            self.frontend.play_sine(300, 500)
            self.timeout(1)
            
        self.timeout(0.5)
        self.trial_active = False
        #self.frontend.pause_game(1)
        #self.cue_visible = False
        #time.sleep(1)
        

    def trigger_solenoid(self, solenoid=0, pulse_duration=25):
        self.frontend.send({'instruction': 'pulse', 'pin': solenoid, 'data': [pulse_duration]})

    def timeout(self, duration):
        self.t_timeout_end = time.time() + duration
        