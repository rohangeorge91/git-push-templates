FROM python:3.5.2-alpine
MAINTAINER Anon Ray <anon@hasura.io>

# copy requirements and install dependencies before copying source code as
# copying the entire directory at once will trigger the install step whenever
# source code changes
COPY requirements.txt /
RUN pip3 install -r /requirements.txt

# Copy the source
COPY helloworld /app
WORKDIR /app

CMD ["gunicorn", "-w 4", "-b 0.0.0.0:8080", "helloworld.wsgi"]
