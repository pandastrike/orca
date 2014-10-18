FROM base/archlinux
# This is the Dockerfile for setting up an Orca Cluster, based on CoreOS technology.
# Start with the Arch image.
MAINTAINER Dan Yoder (dan@pandastrike.com)

#============================================
# INSTALLATION
#============================================
# Install dependencies.
RUN pacman -Syu --noconfirm wget
RUN pacman -Syu --noconfirm gnupg


# Pull the install script from GitHub.
RUN curl https://raw.githubusercontent.com/coreos/init/master/bin/coreos-install > init
RUN chmod +x init
RUN ./init
