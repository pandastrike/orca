#===============================================================================
# Orca - Sonar                                        David Harper - PandaStrike
#===============================================================================
# Sonar is a NodeJS module that is part of the Orca project.  It is intended to
# supplement etcd and provide a DNS-like function for service discovery.  This
# module is passed a human-friendly URL, specifying a given service.  This
# module then searches the etcd key-value store, parses the reply, and returns
# the IP Address for the requested service in the CoreOS cluster.

#=========================
# Modules
#=========================
http = require 'http'

#=========================
# Module Definition
#=========================
module.exports =
  lookup: (url) ->
    # This function is passed a human friendly URL that specifies a requested
    # service.  We need to return an IP Address.

    # Parse the url.
    names = parseURL url

    # Access etcd and retrieve the JSON object used to register services.
    queryETCD names




#=========================
# Private Methods
#=========================
parseURL = (url) ->
  # At the moment, we can just assume that the url is just a series of short
  # names delimited by "."  This needs to be made more robust in the future.
  url.split "."

queryETCD = (names) ->
  # This function is passed an array of names parsed from the service URL.  If
  # we reverse the order, we can use them as a key to query etcd for a matching value.

  # Reverse the name order and create a path string.
  search_path = reversePath names

  # Contact etcd.  We must configure our request to target the etcd endpoint.
  # Since this module will be inside a CoreOS cluster, it will only run in a
  # Docker container. Therefore, we know that etcd is available through the
  # "docker0" IP bridge.
  config =
    host: "172.17.42.1"
    port: 4001
    path: search_path

  console.log "Accessing etcd @ http://#{config.host}:#{config.port}#{config.path}"
  http.request config, (res) ->
    body = ''

    res.on 'data', (chunk) ->
        body += chunk

    res.on 'end', () ->
        etcdRecord = JSON.parse body
        console.log "Got response: #{body}"






reversePath = (array) ->
  # This function takes an array and forges a string from its reversed elements.
  # The initial string is neccessary to access etcd values. "/v2/keys" accesses
  # the key-store in etcd.  'orca-sonar' is the namespace reserved by this module.
  temp = "/v2/keys/orca-sonar"
  for i in [array.length - 1 .. 0]
    temp + array[i] + "/"

  return temp
