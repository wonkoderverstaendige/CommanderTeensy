from .Experiment import ExperimentSkeleton
import logging
import random
import time
import math

TRANSLATION_FACTOR = 2 ** 16  #
MAX_TRIAL_LENGTH = 10
FACTOR_OVERSHOOT = .1  # movement in wrong direction
START_DELAY_MIN = 0.2
START_DELAY_MAX = 0.5
MAXIMUM_MOVEMENT = 0.05


class Experiment(ExperimentSkeleton):
    def __init__(self, *args, **kwargs):
        super(Experiment, self).__init__(*args, **kwargs)
        #self.frontend.play_sine(10000, 100)
        self.target_visible = False
        self.n_trial = 0
        self.n_success = 0
        self.n_failure = 0
        self.current_goal = 0
        self.starting_position = 0
        self.start_delay = 0
        self.t_start_trial = None
        self.t_timeout_end = None
        self.t_start_timeout_end = None
        self.reward_given = False
        self.max_t_trial = MAX_TRIAL_LENGTH
        self.trial_active == 1
        self.timeout_failure = False

    def start_trial(self, goal=0):
        # state transitions should be communicated to teensy
        self.cue_visible = False
        self.t_start_trial = time.time()

        self.n_trial += 1
        self.starting_position = (random.randint(0, 1) * 2 - 1) * 0.9
        self.x = self.starting_position
        
        self.start_delay = random.uniform(START_DELAY_MIN, math.sqrt(START_DELAY_MAX))**2
        self.t_start_timeout_end = self.timeout(self.start_delay)
        logging.info(f'Starting trial {self.n_trial} from the {"left" if self.x < 0 else "right"} with a delay of {self.start_delay} seconds')
       
        self.trial_active = 1
        
        # not move wheel for 200 - 500 ms

    def update(self, packets):
        
        #if packets and trial_active:
        #    self.x = packets[-1].states[7] / TRANSLATION_FACTOR
                
        if self.trial_active == None:
            self.start_trial()
            
        if self.trial_active == 1:
            if (self.t_start_timeout_end == None):
                self.t_start_timeout_end = self.timeout(self.start_delay)
            elif (time.time() < self.t_start_timeout_end):
                #if (self.x is not self.starting_position):
                if (abs(self.x - self.starting_position) > MAXIMUM_MOVEMENT):
                    self.t_start_timeout_end = self.timeout(self.start_delay)
                    self.x = self.starting_position
                    logging.info(f'Moved the wheel by {abs(self.x - self.starting_position)}. Resetting timeout to {self.t_start_timeout_end-time.time()} seconds')
            else:
                self.x = self.starting_position
                self.cue_visible = True
                self.frontend.play_sine(5000, 100)
                self.timeout_failure = False
                self.trial_active = 2
                
        elif self.trial_active == 2:            
            t_delta = time.time() - self.t_start_trial
            if t_delta > self.max_t_trial:                    
                self.x = self.starting_position
                if not self.timeout_failure:
                    self.t_timeout_end = self.timeout(2)
                    self.timeout_failure = True
                if self.t_timeout_end < time.time() and self.timeout_failure:
                    self.end_trial(False, result=('timeout', t_delta))
                
            p_delta = abs(self.x - self.current_goal)
            if p_delta > 1 + FACTOR_OVERSHOOT:
                self.x = self.starting_position
                if not self.timeout_failure:
                    self.t_timeout_end = self.timeout(2)
                    self.timeout_failure = True
                if self.t_timeout_end < time.time() and self.timeout_failure:
                    self.end_trial(success=False, result=('overshoot', t_delta))
            
            #success = self.x < self.current_goal if self.current_goal < 0 else self.x > self.current_goal
            success = (abs(self.current_goal-self.x) <= 0.1)
            if success:
                self.end_trial(success, ('goal', t_delta))
           
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
            
        self.start_trial()
        
    def trigger_solenoid(self, solenoid=0, pulse_duration=25):
        logging.debug('GIVING THE JUICE!')
        self.frontend.send({'instruction': 'pulse', 'pin': solenoid, 'data': [pulse_duration]})

    def timeout(self, duration):
        return time.time() + duration
        