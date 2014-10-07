{resolve} = require "path"
{resource} = require "shred"


module.exports = resource "https://api.digitalocean.com/v2/",

  droplets: (resource) ->
    resource "droplets",
      list:
        method: "GET"
        expect: 200

      create:
        method: "POST"
        expect: 202
        headers:
          "content-type": "application/json"

  images: (resource) ->
    resource "images",
      list:
        method: "GET"
        expect: 200

  keys: (resource) ->
    resource "account/keys",
      list:
        method: "GET"
        expect: 200
