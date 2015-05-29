#
# The Seginus Dockerfile based on Ubuntu.
#

# Pull base image.
FROM ubuntu:14.04

MAINTAINER TADOKORO Saneyuki saneyan@gfunction.com

# Update and upgrade default packages.
RUN sed -i s/archive.ubuntu.com/ftp.jaist.ac.jp/ /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get clean

# Install packages.
RUN apt-get install -y python-pip git curl vim nano openssh-client
RUN pip install --ignore-installed awscli

# Override a symlink for Bash.
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ADD . /src
WORKDIR /src
RUN mkdir /src/backups
RUN mkdir /root/.aws
RUN touch /var/log/cron.log

CMD ["/src/setup.sh"]
