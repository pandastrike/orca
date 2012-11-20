require "fate"
require "fate/repl"

module TaskHelpers
  def self.fate
    configuration = {
      :commands => {
        "nodes" => {
          "1" => "bin/node -e config/examples/environment.cson -n si_events",
          "2" => "bin/node -e config/examples/environment.cson -n si_events",
        }
      }
    }
    @fate ||= Fate.new(
      configuration,
    )
  end
end

task "test" => "start" do
  sh "bin/lead -e config/examples/environment.cson -t config/examples/test.cson"
end

task "start" do
  TaskHelpers.fate.start
  at_exit do
    TaskHelpers.fate.stop
  end
end

task "repl" => "start" do
  TaskHelpers.fate.repl
end


directory "build/web"

task "build:web" => "build/web/js/application.js" do
end

file "build/web/js/application.js" => FileList["cs/web/**/*"] do
  sh "ark package < web/manifest.json > build/web/js/application.js"
end

#rule ".json" => ".cson" do |t|
  #sh "node_modules/.bin/cson2json #{t.source} > #{t.name}"
#end

