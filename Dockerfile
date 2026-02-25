# Stage 1: Download PocketBase binary
FROM alpine:latest AS downloader

# Koristimo ARG za verziju (možeš promijeniti na najnoviju sa https://github.com/pocketbase/pocketbase/releases)
ARG PB_VERSION=0.22.1

RUN apk add --no-cache ca-certificates unzip wget && \
    wget https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip -O /tmp/pb.zip && \
    unzip /tmp/pb.zip -d /pb && \
    chmod +x /pb/pocketbase && \
    rm /tmp/pb.zip

# Stage 2: Final image - alpine za stabilnost, logovanje i env podršku
FROM alpine:latest

# Kopiraj binary i certifikate
COPY --from=downloader /pb/pocketbase /usr/local/bin/pocketbase
COPY --from=downloader /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Osiguraj da imamo shell za bolje logovanje i debugging
RUN apk add --no-cache bash

# Expose port (Railway koristi $PORT, ali expose 8090 za dokumentaciju)
EXPOSE 8090

# Start komanda sa echo za vidljivost u logovima + exec za pravilno signal handling
CMD ["/bin/sh", "-c", "echo 'PocketBase starting on port $PORT...' && exec /usr/local/bin/pocketbase serve --http=0.0.0.0:${PORT:-8090} --dir=/pb_data"]
