require_relative "tasks/tasks.rb"

task "test" => "start" do
  sh "bin/lead -c examples/environment.cson -t examples/test.cson"
end

task "start" do
  Orca::Tasks.fate.start
  at_exit do
    Orca::Tasks.fate.stop
  end
end

desc "Run Orca processes in a Fate repl"
task "repl" => "start" do
  Orca::Tasks.fate.repl
end



#rule ".json" => ".cson" do |t|
  #sh "node_modules/.bin/cson2json #{t.source} > #{t.name}"
#end

