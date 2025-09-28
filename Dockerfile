ARG TARGETOS
ARG TARGETARCH
ARG ALPINE_VERSION=3.22
FROM alpine:${ALPINE_VERSION} AS influxdb-arm64
ARG INFLUX_SOURCE="https://dl.influxdata.com/influxdb/releases/influxdb2-client-2.7.5-linux-arm64.tar.gz"

FROM alpine:${ALPINE_VERSION} AS influxdb-amd64
ARG INFLUX_SOURCE="https://dl.influxdata.com/influxdb/releases/influxdb2-client-2.7.5-linux-amd64.tar.gz"

FROM influxdb-${TARGETARCH}

WORKDIR /backup/aws

RUN apk update && apk add aws-cli gpg gpg-agent
#RUN --mount=type=tmpfs,target=/backup/aws \
#    wget -q -O "./awscliv2.zip" "$AWS_SOURCE" && \
#    unzip awscliv2.zip && \
#    ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update

WORKDIR /backup
RUN --mount=type=tmpfs,target=/backup/influx \
    wget -q -O "./influx/influx.tar.gz" "$INFLUX_SOURCE" && \
    tar xvzf "./influx/influx.tar.gz" -C "./influx" && \
    cp "./influx/influx" "/usr/local/bin/"
WORKDIR /backup
#RUN apk --no-cache add git
COPY ./backup.sh ./backup.sh

LABEL org.opencontainers.image.title="Herpes_Home"
LABEL org.opencontainers.image.description="Herpes_Home Docker Image"

ENTRYPOINT ["sh","backup.sh"]
#CMD [ "api" ]