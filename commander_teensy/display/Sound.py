import multiprocessing
import numpy as np


class SoundProcess(multiprocessing.Process):
    def __init__(self, queue, max_volume, device=10):
        multiprocessing.Process.__init__(self)
        self.queue = queue
        self.audio_fs = 48000
        self.max_volume = max_volume  # global "maximum" volume
        self.device_id = device
        self.sd = None

    def run(self):
        print("Starting sound device process loop")

        # Workaround for sounddevice not dealing well with multiprocessing
        import sounddevice as sd
        self.sd = sd
        sd.default.samplerate = self.audio_fs
        sd.default.device = self.device_id
        while True:
            new_sound = self.queue.get()
            if new_sound is None:
                break

            # DO SOUND HERE
            if new_sound[0] == 'sine':
                duration, frequency, volume = new_sound[1:]
                self.play_sine(duration, frequency, volume)

            elif new_sound[0] == 'wn':
                duration, volume = new_sound[1:]
                self.play_whitenoise(duration, volume)

    def play_sine(self, frequency, duration, volume=1.0, ramp=10):
        n_samples = int(self.audio_fs * duration / 1000)
        samples = np.sin(2 * np.pi * np.arange(n_samples) * frequency / self.audio_fs).astype(
            np.float32) * self.max_volume * volume

        if ramp > 0:
            n_ramp = int(self.audio_fs * ramp / 1000)
            arr_ramp = np.linspace(0, 1, n_ramp).astype(np.float32)
            samples[:n_ramp] *= arr_ramp
            samples[-n_ramp:] *= arr_ramp

        try:
            self.sd.play(samples)
        except self.sd.PortAudioError as e:
            print(f'Failed to play audio: {e}')
            pass

    def play_whitenoise(self, duration, volume=1.0, ramp=10):
        wn = np.random.random(int(self.audio_fs*duration/1000)).astype(np.float32)*(volume * self.max_volume)

        if ramp > 0:
            n_ramp = int(self.audio_fs * ramp / 1000)
            arr_ramp = np.linspace(0, 1, n_ramp).astype(np.float32)
            wn[:n_ramp] *= arr_ramp
            wn[-n_ramp:] *= arr_ramp

        try:
            self.sd.play(wn)
        except self.sd.PortAudioError as e:
            print(f'Failed to play white noise: {e}')



