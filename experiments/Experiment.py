class ExperimentSkeleton:
    def __init__(self, frontend):
        self.frontend = frontend
        self.trial_active = False
        self.x_zero = 0
        self.x = 0

    def update(self, state):
        if self.trial_active:
            pass
        else:
            pass

    def start(self):
        pass

    def start_trial(self):
        self.trial_active = True

    def end_trial(self):
        self.trial_active = False

    def end(self):
        self.frontend.exit()
