#!/usr/bin/env ruby

banks = %w[ lead1 ]

commands = [ 
"ps -o args -C node",
"pkill -f /usr/local/orca/bin/api_server",
"pkill -f /usr/local/orca/bin/tests_worker",
"pkill -f /usr/local/orca/bin/lead",
"cd /usr/local/orca/ ; git pull",
"cd /usr/local/orca/ ; npm install",
"mkdir -p /var/log/orca/",
"daemonize -e /var/log/orca/orca_dispatcher_stderr.log -o /var/log/orca/orca_dispatcher_stdout.log /usr/local/orca/bin/api_server -c /etc/orca/environment.cson; sleep 5",
"daemonize -e /var/log/orca/orca_worker.log -o /var/log/orca/orca_worker.log /usr/local/orca/bin/tests_worker -c /etc/orca/environment.cson; sleep 5",
"daemonize -e /var/log/orca/orca_lead_stderr.log -o /var/log/orca/orca_lead_stdout.log /usr/local/orca/bin/lead -c /etc/orca/environment.cson -t /etc/orca/test.cson; sleep 5",
"sleep 5",
"ps -o args -C node"
]

def localpath(path)
  File.expand_path( File.join( File.dirname( __FILE__ ), path ) ) 
end

config = localpath("befog")

banks.each do |bank|
  commands.each do |cmd|
    command = "befog run #{bank} -p #{config} -c \"#{cmd}\""
    puts(command)
    system(command)
  end 
end

