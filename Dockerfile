FROM base/archlinux
# Start with the Arch image.
# This is the primary Dockerfile for Orca: The open-source, Node, distributed-load tester.
MAINTAINER Dan Yoder (dan@pandastrike.com)


# Pull the Orca repo from GitHub.
RUN git clone https://github.com/pandastrike/orca.git

# NOTE: Switching to this branch is only needed until we merge into Master.
RUN cd orca && git checkout develop

# Install dependencies, starting with Node technology.
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.17.2/install.sh | bash
RUN nvm install 0.11.14

RUN cd orca && npm install
