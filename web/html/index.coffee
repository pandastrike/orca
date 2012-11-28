{HTML, Bootstrap, Pages} = require "nice"
{include} = require "fairmont"

process.on "exit", ->
  page = new Index()
  html = HTML.beautify(page.main())
  console.log html

cdn = (library) ->
  "http://cdnjs.cloudflare.com/ajax/libs/#{library}"

class Index
  
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
          jqplot: "js/jquery.jqplot.min.js"
          jqplot_plugins: "js/jqplot.plugins.js"
          bootstrap: "js/bootstrap.min.js"
          application: "js/application.js"
        css:
          bootstrap: "css/bootstrap.min.css"
          jqplot: "css/jquery.jqplot.min.css"
          application: "css/application.css"
          jqueryUI: "http://code.jquery.com/ui/1.9.1/themes/base/jquery-ui.css"
        
  main: ->
    @page
      title: "Orca"
      javascript: "json2 jquery jqplot jqplot_plugins bootstrap application"
      css: "bootstrap jqueryUI jqplot application"
      body: =>
        @b.container =>
          @content()
  
  header: ->
    @html.h1 "Orca"

  test_list: ->
    @html.div id: "tests", =>
      @html.h3 "Tests"
      @html.ul id: "test_list", =>

  charts: ->
    @html.div id: "charts", =>
      @html.div id: "concurrency_chart"
      @html.div id: "small_charts", =>
        @html.div id: "error_chart"
        @html.div id: "summary"

  content: ->
    @b.row =>
      @b.column width: 12, =>

        @test_list()
        @html.div id: "results", =>
          @html.h3 "Most recent results", id: "test_identifier"
          @charts()

    
    

