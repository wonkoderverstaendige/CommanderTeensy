import pyglet
from pyglet.media.synthesis import Sine

duration = 2000 # duration in ms
frequency = 1000 

sine = Sine(duration=duration/1000, frequency=frequency,
            sample_size=16, sample_rate=48000)

player = pyglet.media.Player()
player.queue(sine)
player.play()

