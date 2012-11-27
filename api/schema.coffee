media_type = (name) ->
  "application/vnd.orca.#{name}+json;version=1.0"
  
module.exports =
  id: "orca"
  properties:

    resource:
      extends: {$ref: "patchboard#resource"}

    test:
      extends: {$ref: "patchboard#resource"}
      mediaType: media_type("test")
      properties:
        name: {type: "string"}
        testId: {type: "string"}
        timestamp: {type: "integer"}
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

    test_list:
      type: "array"
      mediaType: media_type("test_list")
      items: {$ref: "#test"}

    test_summary:
      extends: {$ref: "#resource"}
      mediaType: media_type("test_summary")
      properties:
        steps:
          type: "array"
          #items: {$ref: "#step_summary"}

    step_summary:
      type: "object"
      properties:
        concurrency: {type: "integer"}
        errors: {type: "integer"}
        timeouts: {type: "integer"}
        mean: {type: "number"}
        #stdDev: {type: "number"}
        #median: {type: "number"}
        #max: {type: "number"}
        #min: {type: "number"}

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


