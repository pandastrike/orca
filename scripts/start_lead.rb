#!/usr/bin/env ruby

banks = %w[ lead1 ]

commands = [ 
"ps -o args -C node",
"pkill -f /usr/local/orca/bin/lead",
"mkdir -p /var/log/orca/",
"daemonize -e /var/log/orca/orca_lead_stderr.log -o /var/log/orca/orca_lead_stdout.log /usr/local/orca/bin/lead -e /etc/orca/environment.cson -t /etc/orca/test.cson; sleep 5",
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

