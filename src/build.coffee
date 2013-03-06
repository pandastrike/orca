{resolve} = require "path"

{read,write,chdir} = require "fairmont"
sh = require "node-system"
mkdirp = require "mkdirp"
{parse} = require "cson"
ark = require "ark"

indexPage = require "./web/html/index"

copy = (source,destination) ->
  sh "cp -R #{source} #{destination}"
  
paths = (destination) ->
  source: (resolve __dirname, "web")
  staging: resolve destination, "ark"
  webapp: resolve destination, "web"


build = (configuration,destination) ->
  
  # set up the paths
  {source,staging,webapp} = paths destination
  
  # make sure the build target exists
  mkdirp destination
  
  # set up staging directory
  copy source, staging
  
  # copy the configuration into staging
  write (resolve staging, "configuration.json"), (JSON.stringify (parse (read configuration)))
  
  # install the node_modules in preparation of running ark
  nodeModules = resolve staging, "node_modules"
  mkdirp nodeModules
  chdir staging, -> sh "npm install"
  
  # Begin building the actual Web app
  mkdirp webapp
  
  # copy the assets to the webapp
  copy (resolve staging, "assets/*"), webapp
  
  # add the application javascript ot the Web app
  manifest = (JSON.parse (read (resolve staging, "manifest.json")))
  manifest.source = staging
  write (resolve webapp, "js/application.js"), ark.package manifest: manifest
  
  # add the index.html file to load the app
  write (resolve webapp, "index.html"), indexPage.generate()
  
module.exports = build