# This file is a simple script that overwrites the dns lookup reference contained
# in /etc/resolv.conf.  The container's lookups are directed through the SkyDNS
# container, which has been linked into this container.

# "Fake" domains are properly assigned their address in the cluster.  Domains
# that need an authoritative DNS routing are forwarded to Google's DNS at 8.8.8.8:53.

echo "nameserver $DNS_PORT_53_TCP_ADDR" > /etc/resolv.conf
