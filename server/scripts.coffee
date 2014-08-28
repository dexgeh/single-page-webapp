path = require 'path'
fs = require 'fs'

compiled = {}

sendScript = (req, res, next) ->
  if compiled[req.url]
    res.writeHead 200,
      'Content-Type' : 'text/javascript'
    res.end compiled[req.url]
  else
    filepath = path.join(process.cwd(), 'javascripts', path.normalize req.url)
    filepath = filepath.replace /\.js$/, '.coffee'
    console.log "compiling #{filepath}"
    fs.readFile filepath, 'utf8', (err, content) ->
      return next err if err
      try
        jsx = require('coffee-script').compile content
        jsx = "/** @jsx React.DOM */\n#{jsx}"
        js = require('react-tools').transform jsx
        compiled[req.url] = js
        sendScript req, res, next
      catch e
        next e

module.exports = (req, res, next) ->
  if req.url.match /\.js$/
    sendScript req, res, next
  else
    next()
