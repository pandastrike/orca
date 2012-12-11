#!/usr/bin/env ruby

banks = %w[ lead1 ]

commands = [ 
"ps -o args -C node",
"pkill -f /usr/local/orca/bin/lead",
"ps -o args -C node"
]

def localpath(path)
  File.expand_path( File.join( File.dirname( __FILE__ ), path ) ) 
end

banks.each do |bank|
  commands.each do |cmd|
    config = localpath("befog")
    command = "befog run #{bank} -p #{config} -c \"#{cmd}\""
    puts(command)
    system(command)
  end 
end

