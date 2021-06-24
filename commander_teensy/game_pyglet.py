import pyglet
from pyglet import shapes
from pyglet.gl import *
from pyglet.window import key
import serial
from cobs import cobs
import numpy as np
import base64
import logging
from packet import DataPacket, DataPacketStruct
import struct
import receiver
import argparse
import http.server
import socketserver
import logging
import threading


pyglet.options['vsync'] = True

#SERIAL_PORT = 'COM6'

width = 1000
height = 1000

config = pyglet.gl.Config(double_buffer=True)
window = pyglet.window.Window(width, height,config=config)

batch = pyglet.graphics.Batch()
keyboard = key.KeyStateHandler()

display = pyglet.canvas.Display()
screen = display.get_default_screen()
screen_width = screen.width
screen_height = screen.height

block_size = int(width/30)
x = int(width/2 - block_size/2)
y = int(height/2 - block_size/2)
velocity = 5
changeColor = True

rectangle = shapes.Rectangle(x, y, block_size, block_size, color=(255,255,255), batch=batch)
controlrect = shapes.Rectangle(width-block_size, height-block_size, block_size, block_size, color=(255,255,255), batch=batch)

fps_display = pyglet.window.FPSDisplay(window=window)

#serial_port = 'COM11'
#websocket_port = 5678

#rec = receiver.TeensyCommander(serial_port, websocket_port)
    
def update(dt):
    pass
        
pyglet.clock.schedule_interval(update, 1/120.0)

@window.event
def on_key_press(symbol, modifiers):
    global x
    global y
    if symbol == key.RETURN:
        window.close()
        pyglet.app.exit()

    elif symbol == key.LEFT:
        x -= velocity
        rectangle.x = x

    elif symbol == key.RIGHT:
        x += velocity
        rectangle.x = x


@window.event
def on_draw():
    window.clear()
    global changeColor
    print(rec.get_xpos())
    rectangle.x = rectangle.x + rec.get_xpos()/2
    # TESTING
    #rectangle.x = rec.get_xpos()/2
    
    
    if changeColor:
        controlrect.color = (255,255,255) 
        changeColor = False
    else:
        controlrect.color = (0,0,0)
        changeColor = True
    batch.draw()
    fps_display.draw()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('-s', '--serial_port', default=receiver.SERIAL_PORT)
    parser.add_argument('-w', '--ws_port', default=receiver.WS_PORT)
    parser.add_argument('-H', '--http_port', default=receiver.HTTP_PORT)

    cli_args = parser.parse_args()

    # TODO: reconnecting serial connection
    Handler = http.server.SimpleHTTPRequestHandler
    with socketserver.TCPServer(("127.0.0.1", cli_args.http_port), Handler) as httpd:
        logging.info(f"HTTP server at port {cli_args.http_port}")
        hst = threading.Thread(target=httpd.serve_forever)
        hst.daemon = True
        hst.start()

        tc = receiver.TeensyCommander(cli_args.serial_port, cli_args.ws_port)
        tc.run_forever()
    pyglet.app.run()

