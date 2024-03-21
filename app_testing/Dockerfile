FROM python:3.9-slim

WORKDIR /test
COPY . /test

RUN apt-get update && \
    apt-get install -y chromium chromium-driver && \
    rm -rf /var/lib/apt/lists/* && \
    pip install -r requirements.txt

ENV CHROME_BIN=/usr/bin/chromium
ENV CHROME_DRIVER=/usr/bin/chromedriver

CMD python web_app_unit-testing.py