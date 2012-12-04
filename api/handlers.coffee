# Package Modules
{log,w} = require "fairmont"
Logger = require "ax"

# We want to dispatch tasks based on HTTP requests
Dispatcher = require "pirate/src/channels/composite/worker/dispatcher"

module.exports = (environment) ->
  transport = environment.transport()

  dispatchers = {}
  get_dispatcher = (name) ->
    dispatchers[name] ||= new Dispatcher(transport: transport, name: name)

  # allow dispatchers to gracefully exit
  process.on "exit", ->
    for name, dispatcher of dispatchers
      dispatcher.end()

  logger = new Logger level: "debug"
  levels = w "error warn info debug verbose"
  transport.bus.receive (event,args...) ->
    [_...,level] = event.split "."
    if level in levels
      logger[level] args.join " "
    else
      logger.info "#{event}"

  # TODO: generalize this kludge
  decorate = (media_type, data) ->
    if schema = environment.schema().find(media_type: media_type)
      name = schema.id?.split("#")[1]
      if name == "test"
        data.url = environment.service().generate_url("test", data.testId)
      else if name == "test_list"
        for item in data
          item.url = environment.service().generate_url("test", item.testId)


  # by default, we attempt to construct a dispatcher request from the HTTP
  # request
  taskHandler = (dispatcher_name) ->
    dispatcher = get_dispatcher(dispatcher_name)
    return (context) ->
      
      # Basically, extract a bunch of stuff from the context to make the code below
      # less verbose  
      {request, match} = context
      {body, query} = request
      {path} = match
      # What is the success status?
      success = match.success_status or 200
      # Do we need to respond or not?
      respond = success != 202
      # What's the resource name?
      resource = match.resource_type
      # What's the action we want the resource to take?
      action = match.action_name
      
      # Set the CORS header
      # TODO: Possibly restrict this for some operations?
      context.set_cors_headers("*")
      

      # Dispatch the request and grab the ID so we can attach response handlers ...
      message_id = dispatcher.request
        action: action
        content:
          identifier: path
          body: body
          query: query

      if respond?
        # blurg. not sure about *.result - seems like *.success would be more 
        # consistent
        dispatcher.once "#{dispatcher_name}.#{message_id}.result", (message) ->
          data = message.content
          decorate(match.accept, data)
          context.respond success, data

      dispatcher.once "#{dispatcher_name}.#{message_id}.error", (error) ->
        log error
        (context.error error) if respond?
      

  # return the handlers
  defaultHandler = taskHandler("tests")
  tests:
    list: defaultHandler
    last: defaultHandler
  test:
    get: defaultHandler
    summary: defaultHandler
    results: defaultHandler


