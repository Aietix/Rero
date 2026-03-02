FROM ubuntu:25.10

ENV DEBIAN_FRONTEND=noninteractive

# Copy the package list into the image
COPY packages.txt /tmp/packages.txt

# Install packages
RUN apt-get update && \
    xargs -a /tmp/packages.txt apt-get install -y --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/packages.txt

# Add MongoDB apt repository and install mongosh
RUN curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc -o /tmp/mongodb.asc && \
    gpg --dearmor -o /usr/share/keyrings/mongodb-server-8.0.gpg /tmp/mongodb.asc && \
    rm /tmp/mongodb.asc && \
    echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse" | \
    tee /etc/apt/sources.list.d/mongodb-org-8.0.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends mongosh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install AWS CLI v2 (supports amd64 and arm64)
RUN curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o /tmp/awscliv2.zip && \
    unzip /tmp/awscliv2.zip -d /tmp && \
    /tmp/aws/install && \
    rm -rf /tmp/awscliv2.zip /tmp/aws
