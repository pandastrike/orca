# Package Modules
{log,w} = require "fairmont"
Logger = require "ax"

# We want to dispatch tasks based on HTTP requests
Dispatcher = require "pirate/src/channels/composite/worker/dispatcher"

module.exports = (environment) ->
  transport = environment.transport()

  # Hash of available dispatchers
  dispatchers =
    test_results: new Dispatcher
      transport: transport
      name: "test_results"

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

  # by default, we attempt to construct a dispatcher request from the HTTP
  # request
  defaultHandler = (context) ->
    
    # Basically, extract a bunch of stuff from the context to make the code below
    # less verbose  
    {request, match} = context
    {body,query} = request
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
    

    dispatcher = dispatchers[resource]
    if dispatcher?
      # Dispatch the request and grab the ID so we can attach response handlers ...

      message_id = dispatcher.request
        action: action
        content:
          body: body
          query: query

      if respond?
        # blurg. not sure about *.result - seems like *.success would be more 
        # consistent
        dispatcher.once "#{resource}.#{message_id}.result", (message) ->
            # blurg. why not just message.content?
            context.respond success, message.content

      dispatcher.once "#{resource}.#{message_id}.error", (error) ->
        log error
        (context.error error) if respond?
        
    else
      log new Error "No dispatcher for resource: #{match.resource_type}"
    

  # return the handlers
  test_results:
    last: defaultHandler


