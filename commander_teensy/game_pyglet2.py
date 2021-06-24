from cobs import cobs
import numpy as np
import base64
import logging
from packet import DataPacket, DataPacketStruct
import struct
import matplotlib.pyplot as plt
import pyglet
from pyglet import shapes
from pyglet.gl import *
from pyglet.window import key
import serial
import time


pyglet.options['vsync'] = True

SERIAL_PORT = 'COM6'
ser = serial.Serial(SERIAL_PORT)
ser.flushInput()

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

def readteensy():
    try:
        ser=serial.Serial(SERIAL_PORT,baudrate=9600)
        ser.flushInput()
        ser.flushOutput()
        line=ser.readline()
        print(line)
        if (len(line) > 60):
            line = base64.b64decode(line)
            line = line[:-1]
            print (line)
            #dec = cobs.decode(line)
            #s = struct.unpack(DataPacketStruct, dec)
            #dp = DataPacket(type=s[0], size=s[1], crc16=s[2], packetID=s[3], us_start=s[4], us_end=s[5],analog=s[6:14], states=s[14:22], digitalIn=s[22], digitalOut=s[23], padding=None)
            #print(dp)
        #print(read_ser)
    except serial.SerialException as e:
        logging.error("Can't find teensy: {}".format(e))
    
def test_A():
    with serial.Serial(port='COM6', baudrate=9600) as s:   # open serial port
        #s.flush()
        #time.sleep(0.1)     # wait fro 100 ms for pyserial port to actually be ready
        while True:
            line = s.readline()
            #line = s.read(s.in_waiting)
            #print(line)
            line = base64.b64decode(line)
            print(len(line))
            if (len(line) > 60):
                line = line[:-1]
                dec = cobs.decode(line)
                print(dec)
        #try:
         #   dec = cobs.decode(line)
          #  print(dec)
        #except:
         #   print("An exception occurred")
        #print("Read after delay:  {}".format(s.read(s.in_waiting)))    

def test_B():
    global ser
    #while True:
    try:
        ser_bytes = ser.readline()
        print(base64.b64decode(ser_bytes))
        try:
            decoded_bytes = float(ser_bytes[0:len(ser_bytes)-2].decode("utf-8"))
            print(decoded_bytes)
        except:
            print('error')
            #continue
    except:
        print("Keyboard Interrupt")
        #break
            
    
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
    if changeColor:
        controlrect.color = (255,255,255) 
        changeColor = False
    else:
        controlrect.color = (0,0,0)
        changeColor = True
    test_B()
    batch.draw()
    fps_display.draw()

pyglet.app.run()
    
