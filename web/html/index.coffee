{HTML, Bootstrap, Pages} = require "nice"
{include} = require "fairmont"

process.on "exit", ->
  page = new Application()
  html = HTML.beautify(page.main())
  console.log html

cdn = (library) ->
  "http://cdnjs.cloudflare.com/ajax/libs/#{library}"

class Application
  
  constructor: ->
    @html = new HTML
    @b = new Bootstrap html: @html
    include @, new Pages
      html: @html
      resources:
        javascript:
          json: cdn "json2/20110223/json2.js"
          jquery: cdn "jquery/1.7.2/jquery.min.js"
          jqueryUI: cdn "jqueryui/1.9.1/jquery-ui.min.js"
          bootstrap: "js/bootstrap.min.js"
          application: "js/application.js"
        css:
          bootstrap: "css/bootstrap.min.css"
          application: "css/application.css"
          jqueryUI: "http://code.jquery.com/ui/1.9.1/themes/base/jquery-ui.css"
        
  main: ->
    @page
      javascript: "json2 jquery jqueryUI bootstrap application"
      css: "bootstrap jqueryUI application"
      body: =>
        @b.container =>
          #@masthead()
          #@content()


