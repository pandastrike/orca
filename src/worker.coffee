# Package Modules
{log} = require "fairmont"

# We accept tasks to crawl pages
PirateWorker = require "pirate/src/channels/composite/worker/worker"

class Worker
  
  constructor: (@environment, @name) ->
    @worker = new PirateWorker
      transport: @environment.transport()
      name: @name
      
  run: ->
    {name} = @worker
    
    process.on "exit", =>
      @worker.end()
      
    @worker.on "#{name}.*.task", (task) =>
      if @[task.action]?
        @[task.action] task
      else
        log new Error "Invalid task for '#{name}': #{task.action}"
        
    @worker.on "#{name}.*.error", (error) => log error
      
    @worker.accept()

    console.log "'#{name}' worker is running ..."

  event: (args...) -> @worker.event args...
  
module.exports = Worker


