connect = require("connect")
Patchboard = require("patchboard-server")

api =
  schema: require("./schema")
  resources: require("./resources")
  paths: require("./paths")


class Server
  
  constructor: (@environment) ->
    configuration = @environment.configuration
    {@port} = configuration.api
    api.service_url = configuration.api.service_url
    
    service = new Patchboard.Service(api)
    
    # We pass in the service so that handlers can make use of
    # helpful functions the service can provide.
    handlers = require("./handlers")(environment)
    
    # service.simple_dispatcher returns the http handler function
    # used by Connect or the stdlib http server.
    dispatcher = service.simple_dispatcher(handlers)
    
    @app = connect()
    @app.use(connect.compress())
    @app.use(Patchboard.middleware.json2())
    @app.use(dispatcher)

    return
    
  run: ->
    console.log("HTTP server listening on port #{@port}")
    @app.listen(@port)


module.exports = Server

