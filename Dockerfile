FROM python:3.5.1-slim

MAINTAINER xuming <me@xuming.net>

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y cron && \
    apt-get install -y build-essential && \
    pip install --upgrade pip && \
    pip install --upgrade wheel && \
    apt-get -y install nginx supervisor && \
    pip install --no-cache-dir gunicorn Flask && \
    apt-get install -y libpq-dev && \
    pip install psycopg2 && \
    pip install redis && \
    pip install pandas && \
    mkdir -p /usr/src/app && \
    mkdir -p /usr/src/jobs && \
    apt-get -y clean && \
    apt-get remove -y build-essential && \
    apt-get -y autoremove && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime 

#设置cron脚本
RUN crontab /etc/crontab

WORKDIR /usr/src/app

ONBUILD COPY requirements.txt /usr/src/app/
ONBUILD RUN pip install --no-cache-dir -r requirements.txt

COPY app/ /usr/src/app/

# nginx setup
COPY flask.conf /etc/nginx/sites-available/

RUN rm /etc/nginx/sites-enabled/default && \
    ln -s /etc/nginx/sites-available/flask.conf /etc/nginx/sites-enabled/flask.conf && \
    echo "daemon off;" >> /etc/nginx/nginx.conf

# supervisor setup
RUN mkdir -p /var/log/supervisor && \
    mkdir -p /docker-entrypoint-init.d
COPY supervisor/ /etc/supervisor/
COPY docker-entrypoint.sh /
# COPY crontab /etc

EXPOSE 80
CMD ["/docker-entrypoint.sh"]
