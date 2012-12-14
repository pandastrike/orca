module Orca

  module Tasks
    extend Rake::DSL

    def self.fate
      require "fate"
      require "fate/repl"

      configuration = {
        :commands => {
          "api" => "bin/api_server -c config/examples/environment.cson",
          "http_server" => "node_modules/.bin/nserver -d build/web/",
          "workers" => {
            "tests" => "bin/tests_worker -c config/examples/environment.cson"
          },
          "nodes" => {
            "1" => "bin/node -c config/examples/environment.cson -n si_events",
            "2" => "bin/node -c config/examples/environment.cson -n si_events",
          }
        }
      }
      @fate ||= Fate.new(
        configuration
        #:output => {
          #"mongo" => File.new("/dev/null", "w")
        #}
      )
    end

  end
end

