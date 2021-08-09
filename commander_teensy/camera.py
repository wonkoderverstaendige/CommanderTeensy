# https://picamera.readthedocs.io/en/release-1.13/recipes2.html#web-streaming
import argparse
import io
import logging
import os
import socketserver
from datetime import datetime
from http import server
from threading import Condition
from pathlib import Path

try:
    import picamera
except ImportError:
    import fake_picamera as picamera

# Create the html page for the stream
PAGE = """\
<html>
<head>
<title>MouseCam</title>
</head>
<body>
<center>
<h1>Streaming the setup</h1>
<img src="stream.mjpg" width="1280" height="768" />
</center>
</body>
</html>
"""

PORT = 8111


# Define a class for the streaming output
class StreamingOutput(object):
    def __init__(self):
        self.frame = None
        self.buffer = io.BytesIO()
        self.condition = Condition()

    def write(self, buf):
        if buf.startswith(b'\xff\xd8'):
            # New frame, copy the existing buffer's content and notify all
            # clients it's available
            self.buffer.truncate()
            with self.condition:
                self.frame = self.buffer.getvalue()
                self.condition.notify_all()
            self.buffer.seek(0)
        return self.buffer.write(buf)


# Create handler for the stream, showing the stream or an error message
class StreamingHandler(server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/':
            self.send_response(301)
            self.send_header('Location', '/index.html')
            self.end_headers()
        elif self.path == '/index.html':
            content = PAGE.encode('utf-8')
            self.send_response(200)
            self.send_header('Content-Type', 'text/html')
            self.send_header('Content-Length', str(len(content)))
            self.end_headers()
            self.wfile.write(content)
        elif self.path == '/stream.mjpg':
            self.send_response(200)
            self.send_header('Age', str(0))
            self.send_header('Cache-Control', 'no-cache, private')
            self.send_header('Pragma', 'no-cache')
            self.send_header('Content-Type', 'multipart/x-mixed-replace; boundary=FRAME')
            self.end_headers()
            try:
                while True:
                    with http_stream.condition:
                        http_stream.condition.wait()
                        frame = http_stream.frame
                    self.wfile.write(b'--FRAME\r\n')
                    self.send_header('Content-Type', 'image/jpeg')
                    self.send_header('Content-Length', str(len(frame)))
                    self.end_headers()
                    self.wfile.write(frame)
                    self.wfile.write(b'\r\n')
            except Exception as e:
                logging.warning(
                    'Removed streaming client %s: %s',
                    self.client_address, str(e))
        else:
            self.send_error(404)
            self.end_headers()


class StreamingServer(socketserver.ThreadingMixIn, server.HTTPServer):
    allow_reuse_address = True
    daemon_threads = True


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-p', '--port', default=PORT)
    parser.add_argument('-v', '--verbose', action='count', default=2, help="Increase logging verbosity")
    parser.add_argument('-o', '--output', help='Output directory, created if not existing', default='/home/pi/data')
    parser.add_argument('-f', '--fps', default=30, help='Framerate', type=float)
    parser.add_argument('-r', '--resolution', default='800x600', help='Resolution for video written to disk')
    parser.add_argument('-R', '--rotate', default=0, help='Rotate the image (in degrees, steps of 90°', type=int)

    cli_args = parser.parse_args()

    # Create date and time for the filename
    dateTimeObj = datetime.now()
    timestampStr = dateTimeObj.strftime("%Y-%b-%d_%H-%M-%S")

    save_dir = Path(cli_args.output).resolve()
    if not save_dir.is_dir():
        print(save_dir)
    assert save_dir.is_dir()

    if not os.path.exists(save_dir):
        os.makedirs(save_dir)

    filename = save_dir / f'commanderCam_{timestampStr}.h264'

    frame_width, frame_height = map(int, cli_args.resolution.split('x'))
    frame_width_web = int(frame_width / 2)
    frame_height_web = int(frame_height / 2)
    logging.debug(f'resolution: {frame_width} x {frame_height} : {frame_width_web} x {frame_height_web}')

    with picamera.PiCamera(resolution=f'{frame_width}x{frame_height}', framerate=cli_args.fps) as camera:
        http_stream = StreamingOutput()

        # record to stream
        camera.start_recording(http_stream, format='mjpeg')

        # record to local disk
        camera.start_recording(str(filename), splitter_port=2, resize=(frame_width_web, frame_height_web))
        camera.wait_recording(1)
        try:
            address = ('', cli_args.port)
            server = StreamingServer(address, StreamingHandler)
            server.serve_forever()
        finally:
            camera.stop_recording()
