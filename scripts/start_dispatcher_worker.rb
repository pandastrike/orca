#!/usr/bin/env ruby

banks = %w[ lead1 ]

commands = [ 
"ps -o args -C node",
"pkill -f /usr/local/orca/bin/api_server",
"pkill -f /usr/local/orca/bin/tests_worker",
"mkdir -p /var/log/orca/",
"daemonize -e /var/log/orca/orca_dispatcher_stderr.log -o /var/log/orca/orca_dispatcher_stdout.log /usr/local/orca/bin/api_server -e /etc/orca/environment.cson; sleep 5",
"daemonize -e /var/log/orca/orca_worker.log -o /var/log/orca/orca_worker.log /usr/local/orca/bin/tests_worker -e /etc/orca/environment.cson; sleep 5",
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

