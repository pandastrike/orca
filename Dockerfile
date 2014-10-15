FROM base/archlinux
# Start with the Arch image.
# This is the Dockerfile for an Orca Worker.
MAINTAINER Dan Yoder (dan@pandastrike.com)

#============================================
# INSTALLATION
#============================================

# Pull the Orca repo from GitHub.
RUN pacman -Syu --noconfirm git
RUN git clone https://github.com/pandastrike/orca.git

# NOTE: Switching to this branch is only needed until we merge into Master.
RUN cd orca && git checkout develop

# Install dependencies, starting with Node technology.  Be careful with the node sub-version.
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.17.2/install.sh | bash
RUN source ~/.nvm/nvm.sh && nvm install 0.11

RUN cd orca && \
    source ~/.nvm/nvm.sh && nvm use 0.11 && \
    npm install
