import time
from pysinewave import SineWave
import numpy as np
import matplotlib.pyplot as plt
from playsound import playsound
#import pyaudio
import numpy as np
import sounddevice as sd

def play_sinewave(frequency, duration):
    sinewave = SineWave()
    sinewave.set_frequency(frequency)
    #sinewave.set_amplitude(25)
    sinewave.play()
    time.sleep(duration)
    
    
def play_sinemanual(frequency, duration):
    samplerate = 44100
    T = 1/samplerate
    N = samplerate * duration
    omega = 2 * np.pi * frequency
    time = np.arange(N)*T
    sine = np.sin(omega*time)
    playsound(sine)
    
def test_sine():
    #p = pyaudio.PyAudio()
    volume = 0.5     # range [0.0, 1.0]
    fs = 44100       # sampling rate, Hz, must be integer
    duration = 1.0   # in seconds, may be float
    f = 440.0        # sine frequency, Hz, may be float
    # generate samples, note conversion to float32 array
    samples = (np.sin(2*np.pi*np.arange(fs*duration)*f/fs)).astype(np.float32)
    # for paFloat32 sample values must be in range [-1.0, 1.0]
    """
    stream = p.open(format=pyaudio.paFloat32,
                    channels=1,
                    rate=fs,
                    output=True)
    # play. May repeat with different volume values (if done interactively) 
    stream.write(volume*samples)
    """
    sd.play(samples, fs)

    #stream.stop_stream()
    #stream.close()

    #p.terminate()
    
test_sine()
    
    
#play_sinewave(1000, 2)