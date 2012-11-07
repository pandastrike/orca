Transport = require "pirate/src/transports/redis"

# TODO: get this from the command line?
module.exports = new Transport
  host: "localhost"
  port: 6379
