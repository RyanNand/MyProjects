import logging
logger = logging.getLogger(__name__)
# If I don't want to propagate to the base logger (this logger)
#logger.propagate = False
logger.info('hello from helper')
