import base64
from pathlib import Path
from datetime import datetime
import logging

class LogWriter:
    def __init__(self):
        self.fname = Path(datetime.now().strftime("%Y%m%d-%H%M%S_%f")[:-3] + '.b64')
        logging.info(f"Opening log file {self.fname.absolute()}")
        self.log_file = open(self.fname, 'w+b')

    def handle_array(self, arr):
        # For future parsing, we need to re-append the line termination symbol \0.
        self.log_file.write(base64.b64encode(arr + b'\0') + b'\n')