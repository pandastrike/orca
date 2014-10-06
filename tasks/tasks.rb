module Orca

  module Tasks
    extend Rake::DSL

    def self.fate
      require "fate"
      require "fate/repl"

      configuration = {
        :commands => {
          "api" => "bin/orca-server -c examples/environment.cson",
          "http_server" => "node_modules/.bin/nserver -d build/web/",
          "workers" => {
            "tests" => "bin/orca-worker -c examples/environment.cson"
          },
          "nodes" => {
            "1" => "bin/orca-node -c examples/environment.cson -n si_events",
          }
        }
      }
      @fate ||= Fate.new(
        configuration, {}
        #:output => {
          #"mongo" => File.new("/dev/null", "w")
        #}
      ).control
    end

  end
end

