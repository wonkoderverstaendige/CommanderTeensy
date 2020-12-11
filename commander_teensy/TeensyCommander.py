import argparse
import logging
import time

import serial
import serial.threaded
import serial.tools.list_ports
import curses

from commander_teensy.Packet import PacketReceiver
from commander_teensy.LogWriter import LogWriter
from commander_teensy.SerialDummy import SerialDummy
from commander_teensy.WebInterface import HTTPServer, WSServer
from commander_teensy.CursesInterface import CursesUI

SERIAL_PORT = 'COM3'
WS_PORT = 5678
HTTP_PORT = 8000
USE_DUMMY = True


class TeensyCommander:
    def __init__(self, serial_port, http_port, ws_port, curses_screen):
        self.n_packet = 0
        self.alive = True
        self.shell_gui = CursesUI(self, curses_screen)
        self.log_writer = LogWriter()
        self.serial_port = serial_port
        self.http_port = http_port
        self.ws_port = ws_port
        self.http_server = HTTPServer(http_port=self.http_port)
        self.ws_server = WSServer(ws_port=self.ws_port)

        try:
            self.ser = serial.Serial(self.serial_port)
        except serial.SerialException as e:
            logging.error("Can't find teensy. {}".format(e))
            if USE_DUMMY:
                logging.warning('Using serial dummy')
                self.dummy = SerialDummy()
                self.ser = self.dummy.ser
            else:
                exit()
        self.serial_reader = serial.threaded.ReaderThread(self.ser, PacketReceiver).__enter__()

        # Data receive callbacks
        self.serial_reader.raw_callbacks.append(self.log_writer.handle_array)
        self.serial_reader.packet_callbacks.append(self.handle_packet)
        self.serial_reader.packet_callbacks.append(self.ws_server.handle_packet)
        self.serial_reader.packet_callbacks.append(self.shell_gui.handle_packet)

    def run_forever(self):
        while self.alive and self.shell_gui.alive:
            if not self.shell_gui.is_alive():
                logging.critical("Shell GUI died!")
                self.alive = False
            time.sleep(1)

    def handle_packet(self, packet):
        self.n_packet += 1


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

    LOG_FORMAT = '[%(asctime)s]{%(filename)s:%(lineno)d} %(levelname)s - %(message)s'
    logging.basicConfig(level=loglevel,
                        format=LOG_FORMAT,
                        datefmt='%H:%M:%S')

    console = logging.StreamHandler()
    console.setLevel(loglevel)
    console.setFormatter(logging.Formatter(LOG_FORMAT))
    log_file = logging.FileHandler('teensy_commander.log', mode='w')
    log_file.setLevel(logging.DEBUG)

    logging.getLogger().handlers.clear()
    logging.getLogger().addHandler(console)
    logging.getLogger().addHandler(log_file)
    logging.getLogger().setLevel(loglevel)

    # TODO: reconnecting serial connection
    logging.info("Known serial ports: " + repr(sorted([comport.device for comport in serial.tools.list_ports.comports()])))
    logging.info(f"Launching Teensy Commander on serial port {cli_args.serial_port} and the web interface on ports http:{cli_args.http_port} + ws:{cli_args.ws_port}")
    tc = TeensyCommander(serial_port=cli_args.serial_port,
                         http_port=cli_args.http_port,
                         ws_port=cli_args.ws_port,
                         curses_screen=screen)
    tc.run_forever()

def cli_entry():
    curses.wrapper(main)

if __name__ == "__main__":
    cli_entry()
