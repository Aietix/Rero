FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

# Copy the package list into the image
COPY packages.txt /tmp/packages.txt

# Install packages
RUN apt-get update && \
    xargs -a /tmp/packages.txt apt-get install -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/packages.txt
