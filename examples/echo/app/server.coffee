((require "net").createServer ((socket) -> socket.pipe socket)).listen 1337
