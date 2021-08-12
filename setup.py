try:
    from setuptools import setup
except ImportError:
    from distutils.core import setup

from commander_teensy.__version__ import VERSION

setup(name='CommanderTeensy',
      description='Experimental setup controller and monitor',
      author='Ronny Eichler',
      author_email='ronny.eichler@gmail.com',
      version=VERSION,
      install_requires=['cobs',
                        'pyserial',
                        'numpy',
                        'pyzmq',
                        'pyglet',
                        'sounddevice',
                        'windows-curses ; platform_system == "Windows"'],
      packages=['commander_teensy'],
      entry_points="""[console_scripts]
            teensy=commander_teensy.TeensyCommander:cli_entry
            game=commander_teensy.display.game:main
            camera=commander_teensy.camera:main"""
      )
