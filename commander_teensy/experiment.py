import receiver
import argparse
import http.server
import socketserver
import logging
import threading
import game_pyglet

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('-s', '--serial_port', default=receiver.SERIAL_PORT)
    parser.add_argument('-w', '--ws_port', default=receiver.WS_PORT)
    parser.add_argument('-H', '--http_port', default=receiver.HTTP_PORT)

    cli_args = parser.parse_args()
    
    tc = receiver.TeensyCommander(cli_args.serial_port, cli_args.ws_port)
    game = game_pyglet.game_pyglet(tc)
    tc.run_forever()
    
        
        
        
        