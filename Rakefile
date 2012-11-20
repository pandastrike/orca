require "fate"
require "fate/repl"

module TaskHelpers
  def self.fate
    configuration = {
      :commands => {
        "nodes" => {
          "1" => "bin/node si_events",
          "2" => "bin/node si_events",
        }
      }
    }
    @fate ||= Fate.new(
      configuration,
    )
  end
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

task "test" => "start" do
  sh "bin/lead config/test.cson"
end


rule ".json" => ".cson" do |t|
  sh "node_modules/.bin/cson2json #{t.source} > #{t.name}"
end

