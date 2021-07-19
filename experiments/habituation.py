from Experiment import ExperimentSkeleton


class Experiment(ExperimentSkeleton):
    def __init__(self):
        super().__init__(self)
        self.frontend.play_sine(200, 0.5)

    def trigger_solenoid(self, solenoid, pulse_duration=25):
        self.frontend.zmq_pub.send_pyobj({'instruction': 'pulse', 'pin': solenoid, 'data': [pulse_duration]})
