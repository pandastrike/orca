{optimistic, callbacks} = require "fairmont"
Transport = require "pirate/src/transports/redis"


storage =
  database: (name) ->
    mongo = require "mongodb"
    storage.server ||= new mongo.Server("localhost", 27017)
    new mongo.Db name, server, {safe: true}
  collection: (name, callback) ->
    callback = optimistic callback
    storage.database("orca_results").open callbacks.fatalError (db) ->
      db.collection name, callbacks.fatalError (collection) ->
        callback collection

transport = new Transport
  host: "localhost"
  port: 6379

module.exports =
  storage: storage
  transport: transport
