FROM ubuntu:25.10

ENV DEBIAN_FRONTEND=noninteractive

# Add MongoDB apt repository for mongosh
RUN apt-get update && apt-get install -y --no-install-recommends gnupg curl && \
    curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | \
    gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor && \
    echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse" | \
    tee /etc/apt/sources.list.d/mongodb-org-8.0.list && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy the package list into the image
COPY packages.txt /tmp/packages.txt

# Install packages
RUN apt-get update && \
    xargs -a /tmp/packages.txt apt-get install -y --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/packages.txt

# Install AWS CLI v2 (supports amd64 and arm64)
RUN curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o /tmp/awscliv2.zip && \
    unzip /tmp/awscliv2.zip -d /tmp && \
    /tmp/aws/install && \
    rm -rf /tmp/awscliv2.zip /tmp/aws
