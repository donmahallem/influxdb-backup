ARG TARGETOS
ARG TARGETARCH

FROM influxdb:2.7-alpine AS influxdb-arm64
ARG AWS_SOURCE="https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip"

FROM influxdb:2.7-alpine AS influxdb-amd64
ARG AWS_SOURCE="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"

FROM influxdb-${TARGETARCH}

WORKDIR /backup/aws

RUN echo $TARGETARCH
RUN --mount=type=tmpfs,target=/backup/aws \
    curl --fail -s "$AWS_SOURCE" -o "./awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install --update

WORKDIR /backup
#RUN apk --no-cache add git
COPY ./backup.sh ./backup.sh

LABEL org.opencontainers.image.title="Herpes_Home"
LABEL org.opencontainers.image.description="Herpes_Home Docker Image"

ENV PORT=$APP_PORT

ENV NODE_ENV="production"

ENTRYPOINT ["sh","backup.sh"]
#CMD [ "api" ]