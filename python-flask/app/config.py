import os


DEVELOPMENT = os.environ.get('DEVELOPMENT', False)
ADMIN_TOKEN = os.environ.get('ADMIN_TOKEN', None)
PROJECT_NAME = os.environ.get('PROJECT_NAME', None)

SECRET_KEY = os.environ.get('SECRET_KEY',
                            '37dehi7h3di6teyliws8oud3ehd7eyd)dof')
