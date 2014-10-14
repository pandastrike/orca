FROM coreos/etcd
# Start with the CoreOS Image.
# This is the primary Dockerfile for Orca: The open-source, Node, distributed-load tester.
MAINTAINER Dan Yoder (dan@pandastrike.com)


# Pull the Orca repo from GitHub.
RUN git clone https://github.com/pandastrike/orca.git

# NOTE: Switching to this branch is only needed until we merge into Master.
RUN cd orca && git checkout develop

# Install dependencies.
RUN apt-get -y update && apt-get -y install npm
RUN cd orca && npm install
