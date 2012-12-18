#!/usr/bin/env ruby

banks = %w[ lead1 node1 ]

def localpath(path)
  File.expand_path( File.join( File.dirname( __FILE__ ), path ) ) 
end

config = localpath("befog")

banks.each do |bank|
  command = "befog rm #{bank} -a -p #{config}"
  puts(command)
  system(command)
end

