#!/usr/bin/env ruby

def localpath(path)
  File.expand_path( File.join( File.dirname( __FILE__ ), path ) )
end

config = localpath("befog")


banks = %w[ lead1 node1 ]

banks.each do |bank|
  command = "befog ls #{bank} -p #{config}"
  puts(command)
  system(command)
end

