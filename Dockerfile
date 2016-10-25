FROM ubuntu
MAINTAINER thomas.steinbach at aikq de

RUN apt-get update && \
    apt-get install -y \
      git \
      faketime

COPY create-commits.sh /usr/local/bin/create-commits
COPY commit-messages.txt /usr/local/bin/commit-messages.txt
RUN chmod +x /usr/local/bin/create-commits

RUN adduser --disabled-password --gecos '' uid1000
USER uid1000

RUN \
  git config --global user.email "fake@mail.net" && \
  git config --global user.name "Fake Author"

VOLUME /workspace

WORKDIR /home/uid1000
