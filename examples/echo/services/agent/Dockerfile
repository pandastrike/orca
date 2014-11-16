FROM base/archlinux
MAINTAINER Dan Yoder (dan@pandastrike.com)
#===============================================================================
# Orca - Agent
#===============================================================================
# This Dockerfile is part of the Orca project. It specifies a container running
# an agent in the Orca.  Agents are Docker containers that are responsible for
# some function in Orca's CoreOS cluster.  They are usually either a Leader or
# Drone, but they can also fulfill some custom service.  Since agents load the
# entire Orca repository, we select their ultimate role at runtime, inside the
# service file that summons this image.

# The Leader is responsible for announcing tests, gathering Drones until a quorum
# is reached, and then collecting the results.

# Drones are agents in the Orca cluster that receive instructions to download
# tests using npm.  Once a quorum is reached, they are instructed to launch the
# test against a target service.  They report their results to the Leader where
# they are aggregated.


#============================================
# INSTALLATION
#============================================

# Install git.
RUN pacman -Syu --noconfirm git

#==============================
# Node v0.11 and CoffeeScript
#==============================
# We need the powerful concurrency technologies that are only available in the currently unstable Node v0.11 and un-released "master" of CoffeeScript. We will have to jump through a couple extra hoops until both are released as via their package managers.

# Install nvm from source.
RUN git clone https://github.com/creationix/nvm.git ~/.nvm && \
  cd ~/.nvm && \
  git checkout `git describe --abbrev=0 --tags`

# To use the commands nvm and npm, we need to prefix those commands with a source command, followed by "nvm use v0.11" (starting after this "nvm install" command, of course).
RUN source ~/.nvm/nvm.sh && nvm install 0.11

# Now install the un-relased "master" branch of CoffeeScript.
RUN source ~/.nvm/nvm.sh && nvm use 0.11 && \
    npm install -g jashkenas/coffee-script
#================================

# Pull the Orca repo from GitHub.
RUN git clone https://github.com/pandastrike/orca.git

# Install all other modules / dependencies.
RUN cd orca && \
    source ~/.nvm/nvm.sh && nvm use 0.11 && \
    npm install
