FROM alpine:3.20 AS build

WORKDIR /app

RUN apk update \
	&& apk upgrade \
	&& apk add go

COPY main.go /app/main.go

RUN go mod init github.com/itbm/postgresql-backup-s3 \
	&& go get github.com/robfig/cron/v3 \
	&& go build -o out/go-cron

FROM alpine:3.20
LABEL maintainer="ITBM"

RUN apk update \
	&& apk upgrade \
	&& apk add coreutils postgresql16-client aws-cli openssl \
	&& rm -rf /var/cache/apk/*

COPY --from=build /app/out/go-cron /usr/local/bin/go-cron

ENV POSTGRES_DATABASE **None**
ENV POSTGRES_HOST **None**
ENV POSTGRES_PORT 5432
ENV POSTGRES_USER **None**
ENV POSTGRES_PASSWORD **None**
ENV POSTGRES_EXTRA_OPTS ''
ENV S3_ACCESS_KEY_ID **None**
ENV S3_SECRET_ACCESS_KEY **None**
ENV S3_BUCKET **None**
ENV S3_REGION us-west-1
ENV S3_PREFIX 'backup'
ENV S3_ENDPOINT **None**
ENV S3_S3V4 no
ENV SCHEDULE **None**
ENV ENCRYPTION_PASSWORD **None**
ENV DELETE_OLDER_THAN **None**

ADD run.sh run.sh
ADD backup.sh backup.sh

CMD ["sh", "run.sh"]
