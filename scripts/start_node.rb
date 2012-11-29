#!/usr/bin/env ruby

banks = %w[ node1 ]

commands = [ 
"ps -o args -C node",
"pkill -f /usr/local/orca/bin/node",
"mkdir -p /var/log/orca/",
"daemonize -e /var/log/orca/orca_node_stderr.log -o /var/log/orca/orca_node_stdout.log /usr/local/orca/bin/node -e /etc/orca/environment.cson -n si_events; sleep 5",
"ps -o args -C node"
]

def localpath(path)
  File.expand_path( File.join( File.dirname( __FILE__ ), path ) ) 
end

banks.each do |bank|
  commands.each do |cmd|
    config = localpath("../../configurations/orca/befog")
    command = "befog run #{bank} -p #{config} -c \"#{cmd}\""
    puts(command)
    system(command)
  end 
end

