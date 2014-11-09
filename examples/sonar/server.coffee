dns = require 'orca-sonar.coffee'

sampleURL = payload.test

#{host, port} = dns.lookup sampleURL
reply = dns.lookup sampleURL

console.log "Orca-Sonar has replied."
