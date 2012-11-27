module.exports =

  tests:
    actions:

      last:
        method: "GET"
        response_schema: "test"
        status: 200

      list:
        method: "GET"
        response_schema: "test_list"
        status: 200
        # TODO query options

  test:
    actions:

      get:
        method: "GET"
        response_schema: "test"
        status: 200

      results:
        method: "GET"
        response_schema: "test_result"
        status: 200

      summary:
        method: "GET"
        response_schema: "test_summary"
        status: 200



