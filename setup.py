try:
    from setuptools import setup
except ImportError:
    from distutils.core import setup

setup(name='CommanderTeensy',
      description='Experimental setup controller and monitor',
      author='Ronny Eichler',
      author_email='ronny.eichler@gmail.com',
      version='0.2.5',
      install_requires=['cobs',
                        'pyserial',
                        'numpy',
                        'curses ; platform_system != "Windows"',
                        'windows-curses ; platform_system == "Windows"'],
      packages=['commander_teensy'],
      entry_points="""[console_scripts]
            teensy=commander_teensy.TeensyCommander:cli_entry"""
      )
