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

CMD ./kibana/kibana-4.0.0-BETA1.1/bin/kibana
