FROM base/archlinux
# This is the Dockerfile for service SkyDNS, used to coordinate the many moving
# pieces of Orca. Start with the Arch Linux image as the base.

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


#============================================
# START
#============================================
CMD cd go/src/github.com/skynetservices/skydns && \
    ./skydns
