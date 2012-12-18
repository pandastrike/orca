#!/usr/bin/env ruby


scope, cmd = ARGV

if scope.downcase == "all"
  scope = "-q aws"
end


def localpath(path)
  File.expand_path( File.join( File.dirname( __FILE__ ), path ) )
end

config = localpath("befog")
command = "befog run #{scope} -p #{config} -c \"#{cmd}\""
puts(command)
system(command)

