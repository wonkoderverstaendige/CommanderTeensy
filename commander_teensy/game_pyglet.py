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
import time
import sounddevice as sd

pyglet.options['vsync'] = True

#width = 1000
#height = 1000

display = pyglet.canvas.Display()
screen = display.get_default_screen()
screen_width = screen.width
screen_height = screen.height
scale =2

config = pyglet.gl.Config(double_buffer=True)
#window = pyglet.window.Window(int(round(screen_width/scale,0)), int(round(screen_height/scale,0)),config=config,resizable=True, fullscreen=True)
window = pyglet.window.Window(screen_width, screen_height, config=config, vsync=True)
#glScalef(2.0, 2.0, 2.0)

batch = pyglet.graphics.Batch()
keyboard = key.KeyStateHandler()

block_size = int(screen_width/35)
x = int(screen_width/2 - block_size/2)
y = int(screen_height/2 - block_size/2)
velocity = 5
changeColor = True
#testX = 0

rectangle = shapes.Rectangle(x, y, block_size, block_size, color=(255,255,255), batch=batch)
controlrect = shapes.Rectangle(screen_width-block_size, screen_height-block_size, block_size, block_size, color=(255,255,255), batch=batch)

fps_display = pyglet.window.FPSDisplay(window=window)

serial_port = 'COM5'
websocket_port = 5678

rec = receiver.TeensyCommander(serial_port, websocket_port)
    
def update(dt):
    pass
        
pyglet.clock.schedule_interval(update, 1/60.0)

def play_sinewave(frequency, duration):
    volume = 0.5
    fs = 44100
    samples = (np.sin(2*np.pi*np.arange(fs*duration)*frequency/fs)).astype(np.float32)
    sd.play(samples, fs)

    

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
    global testX
    
    rectangle.x = abs(rec.get_xpos()/40%1950)-block_size;
    #rectangle.x = rectangle.x + testX/2
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
    
play_sinewave(1000, 2)
pyglet.app.run()

"""
How can we use the receiver, if we don't make a receiver object in the game?
if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('-s', '--serial_port', default=receiver.SERIAL_PORT)
    parser.add_argument('-w', '--ws_port', default=receiver.WS_PORT)
    parser.add_argument('-H', '--http_port', default=receiver.HTTP_PORT)

    cli_args = parser.parse_args()
    
    pyglet.app.run()

    # TODO: reconnecting serial connection
    Handler = http.server.SimpleHTTPRequestHandler
    with socketserver.TCPServer(("127.0.0.1", cli_args.http_port), Handler) as httpd:
        logging.info(f"HTTP server at port {cli_args.http_port}")
        hst = threading.Thread(target=httpd.serve_forever)
        hst.daemon = True
        hst.start()
        tc = receiver.TeensyCommander(cli_args.serial_port, cli_args.ws_port)
        #testX = tc.get_xpos()/2
        tc.run_forever()

"""

    
