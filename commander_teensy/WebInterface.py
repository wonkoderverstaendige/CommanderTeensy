import http.server
import json
import logging
import socketserver
import threading
from pathlib import Path

import numpy as np

from websocket_server import WebsocketServer as ReconnectingWebsocketServer

WEB_DIRECTORY = (Path(__file__).parent / '../web').resolve().as_posix()


def bitlist(num, nbits=16):
    """Integer to list of bits"""
    # TODO: pad zeros with string formatter
    bl = list(map(int, bin(num)[2:]))
    # pad with leading zeros
    bl = [0] * (nbits - len(bl)) + bl
    return bl


class NumpyEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, np.ndarray):
            return obj.tolist()
        return json.JSONEncoder.default(self, obj)


class HttpRequestHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=WEB_DIRECTORY, **kwargs)


class HTTPServer(threading.Thread):
    def __init__(self, http_port):
        super(HTTPServer, self).__init__(daemon=True)

        logging.info(f"Launching HTTP server for directory {WEB_DIRECTORY} on port {http_port}")
        self.server = socketserver.TCPServer(("", http_port), HttpRequestHandler)
        self.start()

    def run(self):
        self.server.serve_forever()


class WSServer(threading.Thread):
    def __init__(self, ws_port):
        super(WSServer, self).__init__(daemon=True)
        logging.info(f"Starting Websocket Server on port {ws_port}")
        self.server = ReconnectingWebsocketServer(ws_port)
        self.server.set_fn_new_client(self.ws_client_connect)
        self.server.set_fn_client_left(self.ws_client_left)
        self.server.set_fn_message_received(self.ws_msg_rcv)
        self.start()

    def run(self):
        self.server.run_forever()

    @staticmethod
    def ws_client_connect(client, server):
        # server.send_message_to_all(f'New client connected: {client} to server {server}')
        client_id = "Unknown" if client is None else client["id"]
        logging.info(f'Client {client_id} connected to WebSocket server.')

    @staticmethod
    def ws_client_left(client, server):
        client_id = "Unknown" if client is None else client["id"]
        logging.info(f'Client {client_id} disconnected from WebSocket server.')

    def ws_msg_rcv(self, client, server, message):
        # TODO: Match pinout, which pins are input, which output
        logging.debug(f"WS_msg {message}")
        # if message.startswith('digital'):
        #     pin = int(message.split('digital')[1]) - 16
        #     print(f'toggling pin {pin}')
        #     cmd_p = struct.pack(CommandPacketStruct, *[1, 1, 7 - pin])
        #     enc = cobs.encode(cmd_p)
        #     self.ser.write(enc + b'\0')

    def handle_packet(self, packet):
        if packet.type == 0:
            js = json.dumps({'us_start': packet.us_start, 'us_end': packet.us_end,
                             'analog': packet.analog, 'states': packet.states,
                             'digitalIn': bitlist(packet.digitalIn, nbits=16),
                             'digitalOut': bitlist(packet.digitalOut, nbits=8)},
                            cls=NumpyEncoder)
            self.server.send_message_to_all(js)
