# Ways to create logging reports
import logging
import traceback
from logging.handlers import RotatingFileHandler
import time
from logging.handlers import TimedRotatingFileHandler
import logging.config

# By default, only the following message levels are printed: warning, error, or critical

# Ways to change severity of the messages
# More information on the arguments for basicConfig can be found in the documentation
logging.basicConfig(level=logging.DEBUG, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
                    datefmt='%m/%d/%Y %H:%M:%S')

# These are the types of messages
logging.debug('This is a debug message.')
logging.info('This is a info message.')
logging.warning('This is a warning message.')
logging.error('This is a error message.')
logging.critical('This is a critical message.')

# To log using multiple modules, create internal loggers in that module.
# For example, look at 'helper.py', then just import like below and the basicConfig must be included above
import helper

# Below is how to set up your own log handlers and then write to them (Writing to external files)
logger = logging.getLogger(__name__)      # Set up the logger
# Create handler
stream_h = logging.StreamHandler()        # Create handler for the output console
file_h = logging.FileHandler('file.log')  # Create handler for the external file
# Level and the format
stream_h.setLevel(logging.WARNING)
file_h.setLevel(logging.ERROR)
# Format your message
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
stream_h.setFormatter(formatter)
file_h.setFormatter(formatter)

# This section adds the target for logging and then writes the message to the target
logger.addHandler(stream_h)           # Target the output console
logger.warning('This is a warning')   # Write the message in series
logger.addHandler(file_h)             # Target the file defined above
logger.error('This is an error')      # Write the message
# Setting up your own log handlers and writing to them ends here

# Creating your own config file
# Need "import logging.config"
logging.config.fileConfig('logging.conf')  # Reference the file 'logging.conf' for more information
# Set up the logger and set up the message
logger = logging.getLogger('simpleExample')
logger.debug('This is thee debug message')
# Creating your own config file ends here

# Stack trace - Set up a traceback so that you can more easily find and debug the program
# If you don't know the exception, use "import traceback"
try:
    a = [1, 2, 3]
    val = a[4]
except:
    logging.error("The error is %s", traceback.format_exc())

# Rotating file handler - To help organize logging files by keeping them within file count and memory space specs
# Needs "from logging.handlers import RotatingFileHandler"
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)
# Roll over after 2KB, and keep backup logs app.log.1, app.log.2, etc.
handler = RotatingFileHandler('app.log', maxBytes=2000, backupCount=5)
logger.addHandler(handler)
# Lines 71-72 is just to illustrate how the rotating file handler above works
for _ in range(10000):  # underscore means we don't care about that variable
    logger.info('Hello, world!')

# Timed rotating file handler - To help organize logging files by keeping them within file count and time restrictions
# Needs "from logging.handlers import TimedRotatingFileHandler"
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)
# "s" - seconds, "m" - minutes, "h" - hours, "d" - days, "midnight", w0 - monday, w1 - tuesday, ...
handler = TimedRotatingFileHandler('timed_test.log', when='s', interval=5, backupCount=5)
logger.addHandler(handler)
# Lines 82-84 is just to illustrate how the timed rotating file handler above works
for _ in range(6):
    logger.info('Hello world!')
    time.sleep(5)  # Needs "import time"


# For lots of modules/messages and a long runtime - JSON logger is recommended
