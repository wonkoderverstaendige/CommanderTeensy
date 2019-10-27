try:
    from setuptools import setup
except ImportError:
    from distutils.core import setup

setup(name='CommanderTeensy',
      description='Experimental setup controller and monitor',
      author='Ronny Eichler',
      author_email='ronny.eichler@gmail.com',
      version='0.0.1',
      install_requires=[],
      packages=['commander_teensy'],
      # entry_points="""[console_scripts]
      #       teensy=commander_teensy.commander:main"""
      )
