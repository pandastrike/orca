{async, call} = require "../src/async-helpers"
api = require "../src/provision"
configuration = require "../src/configuration"

log_error = async (error) ->
  console.log error.message
  console.log error.stack
  if error.context?
    console.log status: response.statusCode
    console.log body: yield data

call ->

  try
    {data} = yield api.keys.list
    .authorize
      bearer: configuration.digitalocean.key
    .invoke()

    console.log yield data

  catch error
    log_error error

  # try
  #   {data} = yield api.images.list
  #   .authorize
  #     bearer: configuration.digitalocean.key
  #   .invoke()
  #
  #
  #   console.log yield data
  #
  # catch error
  #   console.log error.message
  #   console.log error.stack
  #   if error.context?
  #     console.log status: response.statusCode
  #     console.log body: yield data
  #

  # try
  #   {data} = yield api.droplets.list
  #   .authorize
  #     bearer: configuration.digitalocean.key
  #   .invoke()
  #
  #
  #   console.log yield data
  #
  # catch error
  #   console.log error.message
  #   if error.context?
  #     console.log status: response.statusCode
  #     console.log body: yield data


  # try
  #   {response, data} = yield api.droplets.create
  #   .authorize
  #     bearer: configuration.digitalocean.key
  #   .invoke
  #     name: "Test"
  #     region: "nyc3"
  #     size: "512mb"
  #     image: 6633779
  #     ssh_keys: ["my-mac"]
  #
  #
  #   console.log yield data
  #
  # catch error
  #   {response, data} = error.context
  #   console.log error.message
  #   console.log status: response.statusCode
  #   console.log body: yield data
