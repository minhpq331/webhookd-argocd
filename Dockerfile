FROM ncarlier/webhookd
MAINTAINER minhpq331@gmail.com

WORKDIR /data
ENV APP_SCRIPTS_DIR=/data/scripts

RUN apk add --no-cache curl

COPY ./docker-entrypoint.sh /

# Add htpasswd
COPY scripts /data/scripts