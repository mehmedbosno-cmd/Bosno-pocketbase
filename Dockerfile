# Stage 1: Download PocketBase
FROM alpine:latest AS downloader

ARG PB_VERSION=0.22.1  # Promijeni na najnoviju sa https://github.com/pocketbase/pocketbase/releases

RUN apk add --no-cache ca-certificates unzip wget && \
    wget https://github.com/pocketbase/pocketbase/releases/download/v$$   {PB_VERSION}/pocketbase_   $${PB_VERSION}_linux_amd64.zip -O /tmp/pb.zip && \
    unzip /tmp/pb.zip -d /pb && \
    chmod +x /pb/pocketbase && \
    rm /tmp/pb.zip

# Stage 2: Final minimal image
FROM scratch

COPY --from=downloader /pb/pocketbase /usr/local/bin/pocketbase
COPY --from=downloader /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

EXPOSE 8090

CMD ["/usr/local/bin/pocketbase", "serve", "--http=0.0.0.0:${PORT:-8090}", "--dir=/pb_data"]
