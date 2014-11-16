{resolve, join} = require "path"
{parse} = require "c50n"
{readFileSync} = require "fs"

abort = (error) ->
  error = (new Error error) unless error.message?
  console.error error.message
  process.abort -1

environment = process.argv[2]

if environment?
  root = resolve environment
  path = join root, "config.cson"
  try
    cson = (readFileSync path).toString()
    module.exports = parse cson
    module.exports.path = root
  catch error
    abort error
else
  abort "Please provide an environment path"
