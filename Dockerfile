# Stage 1: Download PocketBase binary
FROM alpine:latest AS downloader

# Koristimo ENV umjesto ARG da se vrijednost sigurno proširi u RUN
ENV PB_VERSION=0.22.1

RUN apk add --no-cache ca-certificates unzip wget && \
    wget https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip -O /tmp/pb.zip && \
    unzip /tmp/pb.zip -d /pb && \
    chmod +x /pb/pocketbase && \
    rm /tmp/pb.zip

# Stage 2: Minimalni final image
FROM scratch

COPY --from=downloader /pb/pocketbase /usr/local/bin/pocketbase
COPY --from=downloader /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# PocketBase sluša na portu koji Railway dodjeljuje ($PORT varijabla)
EXPOSE 8090

CMD ["/bin/sh", "-c", "echo 'PocketBase starting on port $PORT...' && exec /usr/local/bin/pocketbase serve --http=0.0.0.0:$PORT --dir=/pb_data"]
