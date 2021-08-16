from pyglet.window import key
from collections import deque
import logging
import time


class ExperimentSkeleton:
    def __init__(self, frontend):
        self.frontend = frontend
        self.manual_velocity = 0.01
        self.manual_x = 0
        self.x = 0
        self.y = 0
        self.new_packets = []
        self.last_packets = deque(maxlen=10)
        self.t_last_packet = None
        self.t_start = None
        self.shapes = {}

    def user_input(self, symbol, modifiers):
        if symbol in [key.S]:
            self._start()
            self.start()
        elif symbol in [key.E]:
            self.end()
            self._end()
        self.update_states()

    def _start(self):
        logging.info('Starting experiment.')
        self.t_start = time.time()

    def start(self):
        pass

    def user_input_motion(self, motion):
        # if motion == key.MOTION_LEFT:
        #     self.manual_x -= self.manual_velocity
        # elif motion == key.MOTION_RIGHT:
        #     self.manual_x += self.manual_velocity
        # self.update_states()
        pass

    def process_packets(self, packets):
        if packets:
            self.new_packets = packets
            self.last_packets.extend(packets)
            self.t_last_packet = time.time()

    def update_states(self):
        pass

    def _end(self):
        logging.info(f'Ending experiment.')
        self.frontend.exit()

    def trigger_solenoid(self, solenoid=0, duration=25):
        self.frontend.send({'instruction': 'pulse', 'data': [(solenoid, duration)]})

    def end(self):
        pass
