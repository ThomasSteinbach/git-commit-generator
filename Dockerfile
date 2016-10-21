FROM ubuntu
MAINTAINER thomas.steinbach at aikq de

RUN apt-get update && \
    apt-get install -y \
      git \
      faketime

RUN \
  git config --global user.email "fake@mail.net" && \
  git config --global user.name "Fake Author"

COPY create-commits.sh /root/create-commits.sh
COPY commit-messages.txt /root/commit-messages.txt
RUN chmod +x /root/create-commits.sh

WORKDIR /root
