Test= require "./test.coffee"

test = new Test {url: "http://localhost:1337/"}, (error) ->
  if error
    console.log error
  else
    console.log "Prepared test instance"

test.run (error) ->
  if error
    console.log error
  else
    console.log "Test succeeded"

  


