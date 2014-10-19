FROM dockerfile/java
# This is the Dockerfile for the Kibana 4 visualization tool.
# Kibana requires Java.  Start with the offical Java image, built on an Ubuntu base.
MAINTAINER Dan Yoder (dan@pandastrike.com)

#============================================
# INSTALLATION
#============================================

# Pull the Kibana 4 from the Web.
RUN curl https://download.elasticsearch.org/kibana/kibana/kibana-4.0.0-BETA1.1.zip > kibana-4.0.0-BETA1.1.zip
RUN unzip kibana-4.0.0-BETA1.1.zip -d kibana
RUN rm kibana-4.0.0-BETA1.1.zip

# Now, install the script needed to configure Kibana.  We want to point Kibana at the
# IP address of the Elasticsearch service.  The only way to tell it where that is
# is to edit a .yml file.  Note:  This will need to be adjusted when we merge into Master.
RUN wget --no-check-certificate https://raw.githubusercontent.com/pandastrike/orca/feature/dockerized/scripts/kibana-config.bash
RUN chmod +x kibana-config.bash

#============================================
# START
#============================================

#CMD ./kibana/kibana-4.0.0-BETA1.1/bin/kibana
