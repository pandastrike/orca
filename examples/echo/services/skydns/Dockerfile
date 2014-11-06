FROM base/archlinux
MAINTAINER Dan Yoder (dan@pandastrike.com)
#===============================================================================
# Orca - SkyDNS
#===============================================================================
# This Dockerfile is part of the Orca project. It specifies a container running
# skyDNS, a DNS service we use to find services in our CoreOS cluster.  It's great
# because it keeps track of all the moving parts that power Orca.


#============================================
# INSTALLATION
#============================================

# SkyDNS is powered by Google's Go.  Install Go.
RUN pacman -Syu --noconfirm go
RUN mkdir go

# Go will also need git and Mercurial to get things done.  Install these.
RUN pacman -Syu --noconfirm git
RUN pacman -Syu --noconfirm mercurial

# Now install SkyDNS.
RUN export GOPATH=/go && go get github.com/skynetservices/skydns
RUN cd go/src/github.com/skynetservices/skydns && \
    export GOPATH=/go && go build -v


# Move the binary executable to the top-level of the container so it is easy to call.
RUN cp go/src/github.com/skynetservices/skydns/skydns .

#============================================
# START
#============================================
# We cannot start SkyDNS directly because we need to tell it that the etcd
# endpoint within this Docker container is not standard for a bare CoreOS machine.
