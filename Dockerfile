FROM alpine:3.16

# latest certs
RUN apk add ca-certificates --no-cache && update-ca-certificates

# timezone support
ENV TZ=UTC
RUN apk add --update tzdata --no-cache &&\
    cp /usr/share/zoneinfo/${TZ} /etc/localtime &&\
    echo $TZ > /etc/timezone

# install chrony and place default conf which can be overridden with volume
RUN apk add --no-cache chrony && mkdir -p /etc/chrony
COPY chrony.conf /etc/chrony/.

# see https://github.com/trajano/alpine-libfaketime
COPY --from=trajano/alpine-libfaketime  /faketime.so /lib/faketime.so
ENV LD_PRELOAD=/lib/faketime.so

# port exposed
EXPOSE 123/udp

HEALTHCHECK CMD chronyc tracking || exit 1

# start
CMD [ "/usr/sbin/chronyd", "-d", "-s"]
