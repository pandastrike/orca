require "fate"
require "fate/repl"

module TaskHelpers
  def self.fate
    configuration = {
      :commands => {
        #"redis" => "redis-server",
        #"mongo" => "mongod run --quiet --smallfiles --dbpath data/mongo",
        "nodes" => {
          "1" => "bin/node si_events",
          "2" => "bin/node si_events",
        }
      }
    }
    @fate ||= Fate.new(
      configuration,
      :output =>  {
        "mongo" => File.new("/dev/null", "w"),
        "redis" => File.new("/dev/null", "w"),
      }
    )
  end
end

task "storage" => %w[ data/mongo ]

directory "data/mongo"

task "start" => "storage" do
  TaskHelpers.fate.start
  at_exit do
    TaskHelpers.fate.stop
  end
end

task "repl" => "start" do
  TaskHelpers.fate.repl
end

task "test" => "start" do
  sh "bin/lead local.cson"
end


rule ".json" => ".cson" do |t|
  sh "node_modules/.bin/cson2json #{t.source} > #{t.name}"
end

