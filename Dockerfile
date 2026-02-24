FROM alpine:latest
RUN apk add --no-cache ca-certificates wget unzip

ENV PB_VERSION=0.22.21
RUN wget ... && unzip ... && rm ...  # <-- OVDJE se preuzima PocketBase

WORKDIR /pb
COPY . .
EXPOSE 10000
CMD ["./pocketbase", "serve", "--http=0.0.0.0:10000", "--dir=./pb_data"]  # <-- OVDJE se pokreće
