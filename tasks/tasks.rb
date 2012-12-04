require "fate"
require "fate/repl"

module Orca

  module Tasks
    extend Rake::DSL

    def self.fate
      configuration = {
        :commands => {
          "api" => "bin/api_server -e config/examples/environment.cson",
          "http_server" => "node_modules/.bin/nserver -d build/web/",
          "workers" => {
            "tests" => "bin/tests_worker -e config/examples/environment.cson"
          },
          "nodes" => {
            "1" => "bin/node -e config/examples/environment.cson -n si_events",
            "2" => "bin/node -e config/examples/environment.cson -n si_events",
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

    def self.define_package(options)
      project = options[:name]
      files = options[:files]
      modules = options[:modules]

      task "package:#{project}" => "packages" do
        mkdir_p "packages/#{project}"
        rm_rf "packages/#{project}/node_modules"
        copy_files(project, files)
        copy_modules(project, modules) if modules
        sh "tar -czf packages/#{project}.tgz -C packages #{project}"
      end

      task "package" => "package:#{project}"

      task "clean" do
        rm_rf "packages/#{project}"
        rm_rf "packages/#{project}.tgz"
      end
    end


    def self.copy_files(project, paths)
      paths.each do |path|
        dest = "packages/#{project}/#{path}"
        dir = File.dirname(dest)
        mkdir_p dir
        cp_r path, dest
      end
    end

    def self.copy_modules(project, names)
      mkdir_p "packages/#{project}/node_modules"
      names.each do |name|
        cp_r "node_modules/#{name}", "packages/#{project}/node_modules/"
      end
    end

  end
end

