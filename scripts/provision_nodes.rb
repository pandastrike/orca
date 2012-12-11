#!/usr/bin/env ruby

banks = %w[ node1 ]

scripts = %w[ 
../../si-events-api/ops/scripts/centos/components/install_tuning.sh
../../si-events-api/ops/scripts/centos/components/install_daemonize.sh
../../si-events-api/ops/scripts/centos/components/install_nodejs.sh
~/.ssh/install_github_ssh_keys.sh
install_orca_git_clone.sh
install_orca_config_env.sh
install_orca_config_test.sh
]

def localpath(path)
  File.expand_path( File.join( File.dirname( __FILE__ ), path ) ) 
end

banks.each do |bank|
  scripts.each do |script|
    config = localpath("befog")
    command = "befog run #{bank} -p #{config} --shell #{script}"
    puts(command)
    system(command)
  end 
end

