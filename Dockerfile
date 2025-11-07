FROM ubuntu:22.04

RUN apt-get update
RUN apt-get install -y gnupg curl && \
    curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | \
    gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg \
   --dearmor && \
    echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/8.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-8.2.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends pwgen mongodb-org mongodb-mongosh mongodb-org-database mongodb-org-tools


VOLUME /data/db

ENV AUTH=yes
ENV STORAGE_ENGINE=wiredTiger
ENV JOURNALING=yes

ADD run.sh /run.sh
ADD set_mongodb_password.sh /set_mongodb_password.sh

RUN chmod +x /run.sh
RUN chmod +x /set_mongodb_password.sh

EXPOSE 27017 28017

CMD ["/run.sh"]