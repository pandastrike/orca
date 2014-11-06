FROM base/archlinux
MAINTAINER Dan Yoder (dan@pandastrike.com)

#===============================================================================
# Orca - Target -> Echo Demo
#===============================================================================
# This Dockerfile is part of the Orca project. It specifies a container running
# the target service for the Echo Demo, a simple Node Server that echoes whatever
# message it receives.

# Note that Orca targets do not need to run in Docker or be a part of the same
# cluster running Orca.  Orca just needs to be pointed at a target service's IP
# address, and this is convenient, haha.

# Install git. We use git to pull this example from its public repository into
# this Docker container.
RUN pacman -Syu --noconfirm git
RUN git clone https://github.com/pandastrike/orca.git

# Install Node.  Modern Node comes with its own package manager, npm.
RUN pacman -Syu --noconfirm nodejs

# Install CoffeeScript globally and download any other packages specified by package.json
RUN npm install -g coffee-script
RUN cd orca && git checkout coreos-echo && npm install
