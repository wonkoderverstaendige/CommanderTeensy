import base64
import logging
import struct
import traceback
from collections import namedtuple
from datetime import datetime

from cobs import cobs
from serial.threaded import Packetizer

# uint8_t type;          // 1 B, packet type
# uint8_t size;          // 1 B, packet size
# uint16_t crc16;        // 2 B, CRC16
# unsigned long packetID;// 4 B, running packet count

# unsigned long ts_start;// 4 B, gather start timestamp
# unsigned long ts_end;  // 4 B, transmit timestamp
# uint16_t analog[8];    // 16 B, ADC values
# long states[8];        32 16 B, state variables (encoder, speed, etc)

# uint16_t digitalIn;    // 2 B, digital inputs
# uint8_t digitalOut;    // 1 B, digital outputs
# uint8_t padding[1];    // 1 B, align to 4B

DataPacketDesc = {'type': 'B',
                  'size': 'B',
                  'crc16': 'H',
                  'packetID': 'I',
                  'us_start': 'I',
                  'us_end': 'I',
                  'analog': '8H',
                  'states': '8l',
                  'digitalIn': 'H',
                  'digitalOut': 'B',
                  'padding': 'x'}

DataPacket = namedtuple('DataPacket', DataPacketDesc.keys())
DataPacketStruct = '<' + ''.join(DataPacketDesc.values())
DataPacketSize = struct.calcsize(DataPacketStruct)
logging.info(f"Packet size: {DataPacketSize} Bytes in {DataPacketStruct}")

CommandPacketDesc = {'type': 'B',
                 'size': 'B',
                 'crc16': 'H',
                 'instruction': 'B',
                 'target': 'B',
                 'message': '18s',
                 'padding': 'x'}
CommandPacket = namedtuple('CommandPacket', CommandPacketDesc.keys())
CommandPacketStruct = '<' + ''.join(CommandPacketDesc.values())
CommandPacketSize = struct.calcsize(CommandPacketStruct)
logging.info(f"CommandPacket size: {CommandPacketSize} Bytes in {CommandPacketStruct}")


class PacketReceiver(Packetizer):
    raw_callbacks = []
    packet_callbacks = []

    def connection_made(self, transport):
        super(PacketReceiver, self).connection_made(transport)

    def handle_packet(self, arr):
        """Handle an incoming packet from the serial port. The packetizer has stripped the
        line-termination \0 byte from it already.
        """
        for fn_raw_callback in self.raw_callbacks:
            try:
                fn_raw_callback(arr)
            except BaseException as e:
                logging.critical(e)

        # COBS decode the array
        if not len(arr):
            return
        try:
            dec = cobs.decode(arr)
        except cobs.DecodeError as e:
            logging.warning(str(e))
            return

        packet_type = dec[0]
        if packet_type == 0:
            self.unpack_data_packet(dec)

        elif packet_type == 1:
            self.unpack_command_packet(dec)

        elif packet_type == 2:
            logging.error(f'Received error packet {dec}')

        else:
            logging.error(f'Received unknown packet type: {packet_type} in packet {dec}')

    def unpack_data_packet(self, arr):
        """Handle a data packet by extracting its fields.
        """
        if len(arr) != DataPacketSize:
            logging.warning(f"Incorrect data size. Is: {len(arr)}, expected: {DataPacketSize}. Packet: {arr}")
            return

        # stupid manual struct unpacking is stupid
        s = struct.unpack(DataPacketStruct, arr)
        dp = DataPacket(type=s[0], size=s[1], crc16=s[2], packetID=s[3], us_start=s[4], us_end=s[5],
                        analog=s[6:14], states=s[14:22], digitalIn=s[22], digitalOut=s[23], padding=None)

        # hand over packets to interested parties...
        for fn_packet_callback in self.packet_callbacks:
            try:
                fn_packet_callback(dp)
            except BaseException as e:
                logging.critical(e)


    def unpack_command_packet(self, arr):
        print("Command packet: ", arr)

    def connection_lost(self, exc):
        if exc:
            print('Serial connection loss: ', exc)
            traceback.print_exc()