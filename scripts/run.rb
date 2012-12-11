#!/usr/bin/env ruby

# Examples:
# ./run all shell remote/ps
# ./run all command "free -m"


scope, task, *scripts = ARGV

if scope.downcase == "all"
  scope = "-q aws"
end


def localpath(path)
  File.expand_path( File.join( File.dirname( __FILE__ ), path ) )
end

scripts.each do |script|
  config = localpath("befog")
  command = "befog run #{scope} -p #{config} --#{task} #{script}"
  puts(command)
  system(command)
end

