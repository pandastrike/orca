media_type = (name) ->
  "application/vnd.orca.#{name}+json;version=1.0"
  
module.exports =
  id: "orca"
  properties:

    resource:
      extends: {$ref: "patchboard#resource"}

    test_result:
      extends: {$ref: "#resource"}
      mediaType: media_type("test_result")
      properties:
        testId: {type: "string"}
        timestamp: {type: "integer"}
        results:
          type: "array"
          items: {$ref: "#result"}
        configuration:
          type: "object"
          properties:
            description: {type: "string"}
            quorum: {type: "integer"}
            repeat: {type: "integer"}
            step: {type: "integer"}
            package:
              type: "object"
              properties:
                name: {type: "string"}
                reference: {type: "string"}
    
    result:
      type: "object"
      properties:
        concurrency: {type: "integer"}
        errors: {type: "integer"}
        timeouts: {type: "integer"}
        times:
          type: "array"
          items: {type: "number"}


