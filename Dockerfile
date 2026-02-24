# Koristi Alpine za mali image (smanjuje build vrijeme)
FROM alpine:3.19

# Instaliraj wget i unzip (ako treba)
RUN apk add --no-cache wget unzip

# Download najnoviji PocketBase (promijeni verziju ako treba, npr. v0.21.0)
RUN wget https://github.com/pocketbase/pocketbase/releases/download/v0.21.0/pocketbase_0.21.0_linux_amd64.zip && \
    unzip pocketbase_0.21.0_linux_amd64.zip && \
    rm pocketbase_0.21.0_linux_amd64.zip && \
    chmod +x pocketbase

# Kopiraj tvoje custom fajlove ako imaš (npr. pb_data ako već imaš bazu)
# COPY pb_data /pb_data  # Opcionalno, ako želiš inicijalnu bazu

# Expose port (default 8090)
EXPOSE 8090

# Pokreni PocketBase
CMD ["./pocketbase", "serve", "--http=0.0.0.0:8090"]
