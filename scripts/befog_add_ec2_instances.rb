#!/usr/bin/env ruby

banks = %w[ lead1 ]

def localpath(path)
  File.expand_path( File.join( File.dirname( __FILE__ ), path ) ) 
end

config = localpath("befog")

banks.each do |bank|
  command = "befog add #{bank} -c 1 -s -p #{config}"
  puts(command)
  system(command)
end


banks = %w[ node1 ]

banks.each do |bank|
  command = "befog add #{bank} -c 10 -s -p #{config}"
  puts(command)
  system(command)
end

