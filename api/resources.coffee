module.exports =

  test_results:
    actions:

      last:
        method: "GET"
        response_schema: "test_result"
        status: 200

      #list:
        #method: "GET"
        #query:
          #optional: ["before", "after", "count"]
        #response_schema: "test_lit"
        #status: 200

  #test_result:
    #actions:

      #get:
        #method: "GET"
        #response_schema: "test_result"
        #status: 200



