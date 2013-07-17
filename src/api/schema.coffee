media_type = (name) ->
  "application/vnd.orca.#{name}+json;version=1.0"
  
module.exports =
  id: "orca"
  properties:

    resource:
      extends: {$ref: "patchboard#resource"}

    test_configuration:
      type: "object"
      properties:
        name:
          type: "string"
          description: """
            a URL friendly string to describe a test. Used to determine the name
            of the pub/sub channel on which the leader and nodes will communicate.
          """
        description:
          type: "string"
          description: """
            freeform text.  A good place to describe the service being
            tested for later reference and comparison. E.g.
            "logging an event; 3 dispatchers, 12 workers"
          """
        quorum:
          type: "integer"
          description: """
            the number of Orca nodes required to run the test
          """
        repeat:
          type: "integer"
          description: """
            how many test sets to run
          """
        step:
          type: "integer"
          description: """
            the number of concurrent requests to increase each test set by.
          """
        timeout:
          type: "integer"
          description: """
            number of milliseconds to wait before timing out each test.
          """
        package:
          type: "object"
          description: """
          """
          properties:
            reference:
              type: "string"
              description: """
                a reference to the test package usable by NPM install.
                Could be a URL or file system path.
              """
            name:
              type: "string"
              description: """
                the name of the package, used by the `require` call in Node.js
              """
        options:
          type: "object"
          description: """
            freeform object for passing runtime options to the test code.
          """



    test:
      extends: {$ref: "patchboard#resource"}
      mediaType: media_type("test")
      properties:
        name: {type: "string"}
        testId: {type: "string"}
        timestamp: {type: "integer"}
        configuration: {$ref: "#test_configuration"}

    test_list:
      type: "array"
      mediaType: media_type("test_list")
      items: {$ref: "#test"}

    test_summary:
      extends: {$ref: "#resource"}
      mediaType: media_type("test_summary")
      properties:
        name: {type: "string"}
        testId: {type: "string"}
        timestamp: {type: "integer"}
        configuration: {$ref: "#test_configuration"}
        steps:
          type: "array"
          #items: {$ref: "#step_summary"}

    step_summary:
      type: "object"
      properties:
        concurrency: {type: "integer"}
        errors: {type: "integer"}
        timeouts: {type: "integer"}
        count: {type: "integer"}
        mean: {type: "number"}
        stdev: {type: "number"}
        median: {type: "number"}
        max: {type: "number"}
        min: {type: "number"}

    test_result:
      mediaType: media_type("test_result")
      properties:
        nodes:
          type: "object"
          additionalProperties:
            type: "array"
            items: {$ref: "#step_result"}
    
    step_result:
      type: "object"
      properties:
        concurrency: {type: "integer"}
        errors: {type: "integer"}
        timeouts: {type: "integer"}
        times:
          type: "array"
          items: {type: "number"}


