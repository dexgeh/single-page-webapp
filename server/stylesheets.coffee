path = require 'path'
fs = require 'fs'

stylus = require 'stylus'

compiled = {}

sendCss = (req, res, next) ->
  if compiled[req.url]
    res.writeHead 200,
      'Content-Type' : 'text/css'
    res.end compiled[req.url]
  else
    filepath = path.join(process.cwd(), 'stylesheets', path.normalize req.url)
    filepath = filepath.replace /\.css$/, '.styl'
    console.log "compiling #{filepath}"
    fs.readFile filepath, 'utf8', (err, content) ->
      return next err if err
      stylus.render content, {filename:filepath}, (err, css) ->
        return next err if err
        compiled[req.url] = css
        sendCss req, res, next

module.exports = (req, res, next) ->
  if req.url.match /\.css$/
    sendCss req, res, next
  else
    next()
