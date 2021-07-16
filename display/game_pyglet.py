import argparse
import cobs
import numpy as np
import pyglet
import sounddevice as sd
from pyglet import shapes
from pyglet.window import key
import zmq

from commander_teensy.TeensyCommander import ZMQ_SERVER_PUB_PORT as ZMQ_CLIENT_SUB_PORT
from commander_teensy.TeensyCommander import ZMQ_SERVER_SUB_PORT as ZMQ_CLIENT_PUB_PORT


def play_sinewave(frequency, duration):
    volume = 0.5
    fs = 44100
    samples = (np.sin(2 * np.pi * np.arange(fs * duration) * frequency / fs)).astype(np.float32)
    sd.play(samples, fs)


class PygletGame(pyglet.window.Window):
    def __init__(self, fullscreen=False, resizable=True, vsync=True, buffered=True, screen_id=0):
        self._display = pyglet.canvas.Display()
        self._screen = self.display.get_screens()[screen_id]
        self.sw = self.screen.width
        self.sh = self.screen.height
        # self.sw = 600
        # self.sh = 480
        config = pyglet.gl.Config(double_buffer=buffered)
        pyglet.options['vsync'] = vsync

        super(PygletGame, self).__init__(self.sw, self.sh, config=config, vsync=True, fullscreen=fullscreen,
                                         resizable=resizable)

        self.px_scale = 2.0
        # gl.glScalef(self.px_scale, self.px_scale, self.px_scale)

        self.batch = pyglet.graphics.Batch()
        self.keyboard = key.KeyStateHandler()

        self.block_size = self.sw // 15
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

        self.zmq_ctx = zmq.Context()
        self.zmq_sub = self.zmq_ctx.socket(zmq.SUB)
        self.zmq_sub.setsockopt_string(zmq.SUBSCRIBE, "")
        self.zmq_sub.connect(f"tcp://127.0.0.1:{ZMQ_CLIENT_SUB_PORT}")

        self.zmq_pub = self.zmq_ctx.socket(zmq.PUB)
        self.zmq_pub.connect(f"tcp://127.0.0.1:{ZMQ_CLIENT_PUB_PORT}")

        play_sinewave(1000, 0.1)
        pyglet.app.run()

    def update(self, dt):
        # TODO: State updates should take all received packets into account
        messages = []
        while True:
            try:
                msg = self.zmq_sub.recv_pyobj(zmq.DONTWAIT)
                messages.append(msg)
            except zmq.Again:
                break
        if messages:
            # Using last state variable to update the square position
            self.x = (messages[-1].states[7]/2**16+0.5)*self.sw

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
        if (self.rectangle.x > self.sw/10*9 or self.rectangle.x < self.sw/10*1):
            self.end_trial(1000, 0.5)
        if self.changeColor:
            self.controlrect.color = (255, 255, 255)
            self.changeColor = False
        else:
            self.controlrect.color = (0, 0, 0)
            self.changeColor = True
        self.batch.draw()
        self.fps_display.draw()


    def send_solenoid_cmd(pin, duration):
        packet_type = 1
        packet_size = struct.calcsize(DataPacketStruct)
        packet_crc = 777
        packet_instruction = 0
        packet_target = pin
        packet_message =  str(duration).encode()

        packet = []
        packet.extend([packet_type, packet_size, packet_crc, packet_instruction,
        packet_target, packet_message])

        try:
            ps = struct.pack(CommandPacketStruct, *packet)
        except struct.error as e:
            logging.error(e)
            print(packet)
            return

        enc = cobs.encode(ps)
        print (enc + b'\0')
        self.zmq_pub.send_string(enc + b'\0')
        #rec.send_msg(enc + b'\0')
    
    def end_trial(self, frequency, duration):
        # TODO
        play_sinewave(frequency, duration)
        self.send_solenoid_cmd(10,5)
        #global trialcount
        self.rectangle.x = int(self.sw/2 - self.block_size/2)
        self.x = self.rectangle.x
        #trialcount = trialcount +1
        #print("Trial " + str(trialcount) + " finished")
        sd.wait()

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--screen', type=int, default=0)

    cli_args = parser.parse_args()

    game = PygletGame(screen_id=cli_args.screen)
