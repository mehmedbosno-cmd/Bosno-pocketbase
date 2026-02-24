FROM alpine:latest AS downloader

ARG PB_VERSION=0.22.1  # Provjeri najnoviju na https://github.com/pocketbase/pocketbase/releases
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN apk add --no-cache ca-certificates unzip wget && \
    wget https://github.com/pocketbase/pocketbase/releases/download/v$$   {PB_VERSION}/pocketbase_   $${PB_VERSION}_$$   {TARGETOS}_   $${TARGETARCH}.zip -O /tmp/pb.zip && \
    unzip /tmp/pb.zip -d /pb && \
    chmod +x /pb/pocketbase && \
    rm /tmp/pb.zip

FROM scratch

COPY --from=downloader /pb/pocketbase /usr/local/bin/pocketbase
COPY --from=downloader /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

EXPOSE 8090

CMD ["/usr/local/bin/pocketbase", "serve", "--http=0.0.0.0:${PORT:-8090}", "--dir=/pb_data"]
