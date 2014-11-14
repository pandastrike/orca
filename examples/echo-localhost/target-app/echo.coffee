#===============================================================================
# Orca - Echo Example App
#===============================================================================
# This Node server is part of the Orca project's Echo example. This is a just
# simple server that sends back whatever text it receives.

((require "net").createServer ((socket) -> socket.pipe socket)).listen 1337

console.log '=========================================='
console.log '    The server is online and ready.'
console.log '=========================================='
