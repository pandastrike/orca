# This is the primary Dockerfile for Orca: The open-source, Node, distributed-load tester.
MAINTAINER Dan Yoder (dan@pandastrike.com)

# Start with the CoreOS Image.
FROM coreos


# Pull the Orca repo from GitHub.
RUN git clone git@github.com:pandastrike/orca.git

# This branch is needed until we merge into Master.
RUN cd orca && git checkout develop
