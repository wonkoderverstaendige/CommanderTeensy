import argparse
import logging
import time
from datetime import datetime
import zmq
import threading

import serial
import serial.threaded
import serial.tools.list_ports
import curses

from commander_teensy.Packet import PacketReceiver, pack_command_packet
from commander_teensy.LogWriter import LogWriter
from commander_teensy.SerialDummy import SerialDummy
from commander_teensy.WebInterface import WebInterface, WS_PORT, HTTP_PORT
from commander_teensy.CursesInterface import CursesUI

SERIAL_PORT = 'COM5'
WS_PORT = 5678
HTTP_PORT = 8000

ZMQ_SERVER_PUB_PORT = 5680
ZMQ_SERVER_SUB_PORT = 5681

USE_DUMMY = True


class TeensyCommander:
    def __init__(self, serial_port, http_port, ws_port, curses_screen):
        self.n_packet = 0
        self.packets_per_second = 0
        self.packet_timings = []
        self.zmq_ctx = zmq.Context()
        self.zmq_pub = self.zmq_ctx.socket(zmq.PUB)
        self.zmq_pub.bind(f'tcp://*:{ZMQ_SERVER_PUB_PORT}')

        self.zmq_sub = self.zmq_ctx.socket(zmq.SUB)
        self.zmq_sub.setsockopt_string(zmq.SUBSCRIBE, "")
        self.zmq_sub.bind(f'tcp://*:{ZMQ_SERVER_SUB_PORT}')

        self.alive = True
        self.shell_gui = CursesUI(self, curses_screen)
        time.sleep(0.05)  # give some time to let log display catch all startup messages

        self.log_writer = LogWriter()
        self.serial_port = serial_port

        self.web_server = WebInterface(http_port, ws_port, self)

        try:
            self.ser = serial.Serial(self.serial_port)
            self.ser.flushInput()
        except serial.SerialException as e:
            logging.error("Can't find serial device: {}".format(e))
            if USE_DUMMY:
                logging.warning('Using serial dummy')
                self.dummy = SerialDummy()
                self.ser = self.dummy.ser
                self.serial_port = 'DUMMY'
            else:
                exit()
        self.serial_reader = serial.threaded.ReaderThread(self.ser, PacketReceiver).__enter__()

        # Data receive callbacks
        self.serial_reader.raw_callbacks.append(self.log_writer.handle_array)
        self.serial_reader.packet_callbacks.append(self.handle_packet)
        self.serial_reader.packet_callbacks.append(self.web_server.handle_packet)
        self.serial_reader.packet_callbacks.append(self.shell_gui.handle_packet)

        self.zmq_subscriber = threading.Thread(target=self.subscriber, daemon=True)

    def run_forever(self):
        self.zmq_subscriber.start()
        while self.alive and self.shell_gui.alive:
            if not self.shell_gui.is_alive():
                logging.critical("Shell GUI died!")
                self.alive = False
            time.sleep(1)

    def handle_packet(self, packet):
        self.n_packet += 1
        t_now = time.time_ns() * 0.000000001
        self.packet_timings.append(t_now)
        t_delta = t_now - (self.packet_timings[0] if len(self.packet_timings) < 1000 else self.packet_timings.pop(0))
        try:
            self.packets_per_second = len(self.packet_timings) / t_delta
        except ZeroDivisionError:
            self.packets_per_second = 0
        self.zmq_pub.send_pyobj(packet)

    def subscriber(self):
        while True:
            try:
                msg = self.zmq_sub.recv_pyobj()
            except zmq.ZMQBaseError as e:
                if e.errno == zmq.ETERM:
                    break
                else:
                    raise
            if msg:
                self.send_packet(msg)

    def send(self, msg):
        logging.debug('Send message: ' + str(msg))
        self.pack_packet(msg)

    def pack_packet(self, message):
        logging.debug(f'Packing message: {message}')
        if message.startswith('digital'):
            pin = int(message.split('digital_')[1]) - 16
            packed = pack_command_packet({'pin': pin, 'data': 25})
            self.send_packet(packed)
        else:
            logging.debug('Unknown type!')

    def send_packet(self, packet):
        logging.debug('Send packet ' + str(packet))


def main(screen):
    parser = argparse.ArgumentParser()
    parser.add_argument('-s', '--serial_port', default=SERIAL_PORT)
    parser.add_argument('-w', '--ws_port', default=WS_PORT)
    parser.add_argument('-H', '--http_port', default=HTTP_PORT)
    parser.add_argument('-v', '--verbose', action='count', default=0, help="Increase logging verbosity")

    cli_args = parser.parse_args()

    try:
        loglevel = {
            0: logging.ERROR,
            1: logging.WARN,
            2: logging.INFO,
        }[cli_args.verbose]
    except KeyError:
        loglevel = logging.DEBUG

    log_format = '[%(asctime)s]{%(filename)s:%(lineno)d} %(levelname)s - %(message)s'
    logging.basicConfig(level=loglevel,
                        format=log_format,
                        datefmt='%H:%M:%S')

    console = logging.StreamHandler()
    console.setLevel(loglevel)
    console.setFormatter(logging.Formatter(log_format))

    start_time_str = datetime.now().strftime("%Y%m%d-%H%M%S")
    log_file = logging.FileHandler(f'{start_time_str}_teensy_commander.log', mode='w')
    log_file.setLevel(logging.DEBUG)
    log_file.setFormatter(logging.Formatter(log_format))

    logging.getLogger().handlers.clear()
    logging.getLogger().addHandler(console)
    logging.getLogger().addHandler(log_file)
    logging.getLogger().setLevel(loglevel)

    # TODO: reconnecting serial connection
    logging.info(
        "Known serial ports: " + repr(sorted([comport.device for comport in serial.tools.list_ports.comports()])))
    logging.info(
        f"Launching Teensy Commander on serial port {cli_args.serial_port} and the web interface "
        f"on ports http:{cli_args.http_port} + ws:{cli_args.ws_port}")
    tc = TeensyCommander(serial_port=cli_args.serial_port,
                         http_port=cli_args.http_port,
                         ws_port=cli_args.ws_port,
                         curses_screen=screen)
    tc.run_forever()


def cli_entry():
    curses.wrapper(main)


if __name__ == "__main__":
    cli_entry()
