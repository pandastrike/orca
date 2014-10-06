assert = require "assert"
amen = require "amen"
{publish, subscribe} = require "../src/pub-sub"
{async, call} = require "../src/async-helpers"

call ->
  yield amen.describe "pub-sub", (context) ->
    context.test "publish a message", ->
      {next} = yield subscribe "foobar"
      yield publish "foobar", name: "Dan"
      {name} = yield next()
      assert.equal name, "Dan"
