FROM base/archlinux
MAINTAINER Dan Yoder (dan@pandastrike.com)
#===============================================================================
# Orca - Leader
#===============================================================================
# This Dockerfile is part of the Orca project. It specifies a container running
# an Orca Leader.  The Leader is responsible for annoucing tests, gathering
# Drones until a quorum is reached, and then collecting the results.


#============================================
# INSTALLATION
#============================================

# Install git.
RUN pacman -Syu --noconfirm git

#==============
# Node v0.11
#==============
# We need the powerful technologies only available in the currently unstable Node v0.11. We will have to jump through a couple extra hoops until it is released as a simple pacman package.

# Install nvm from source.
RUN git clone https://github.com/creationix/nvm.git ~/.nvm && \
  cd ~/.nvm && \
  git checkout `git describe --abbrev=0 --tags`

# To use the commands nvm and npm, we need to prefix those commands with a source command, followed by "nvm use v0.11" (starting after this "nvm install" command, of course).
RUN source ~/.nvm/nvm.sh && nvm install 0.11
#=================

# Pull the Orca repo from GitHub.
RUN git clone https://github.com/pandastrike/orca.git

# NOTE: Switching to this branch is only needed until we merge into Master.
RUN cd orca && git checkout coreos-echo

# Install all modules / dependencies.
RUN cd orca && \
    source ~/.nvm/nvm.sh && nvm use 0.11 && \
    npm install -g coffee-script && \
    npm install
