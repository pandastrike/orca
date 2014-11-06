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

# Pull the Orca repo from GitHub.
RUN pacman -Syu --noconfirm git
RUN git clone https://github.com/pandastrike/orca.git

# NOTE: Switching to this branch is only needed until we merge into Master.
RUN cd orca && git checkout coreos-echo

# Install dependencies, starting with Node technology.  Be careful with the node version.
# We need the powerful technologies only available in the currently unstable Node v0.11.
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.17.2/install.sh | bash
RUN source ~/.nvm/nvm.sh && nvm install 0.11

# Install all modules / dependencies.
RUN cd orca && \
    source ~/.nvm/nvm.sh && nvm use 0.11 && \
    npm install
