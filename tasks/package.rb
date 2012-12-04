require_relative "tasks"

desc "Package all components for individual use"
task "package"

directory "packages"

Orca::Tasks.define_package(
  :name => "orca_lead",
  :files => %w[
    bin/lead
    lead.coffee
    environment.coffee
  ],
  :modules => %w[
    cson
    fairmont
    pirate
    optimist
    mongodb
  ]
)

Orca::Tasks.define_package(
  :name => "orca_node",
  :files => %w[
    bin/node
    node.coffee
    environment.coffee
  ],
  :modules => %w[
    cson
    fairmont
    pirate
    optimist
    node-system
  ]
)

Orca::Tasks.define_package(
  :name => "orca_http",
  :files => %w[
    bin/api_server
    api/
    environment.coffee
  ],
  :modules => %w[
    cson
    fairmont
    pirate
    patchboard-server
    connect
  ]
)


Orca::Tasks.define_package(
  :name => "orca_tests_worker",
  :files => %w[
    bin/tests_worker
    api/
    environment.coffee
    worker.coffee
    tests_worker.coffee
  ],
  :modules => %w[
    cson
    fairmont
    pirate
    patchboard-server
    gauss
    mongodb
  ]
)

