require('console-ten').init console

path = require 'path'

express = require 'express'

app = express()
app.disable 'x-powered-by'
app.use express.static 'public'
app.use express.static 'bower_components'
app.use require './bodyParser'
app.use require './scripts'
app.use require './stylesheets'
app.use require './requestLogger'
app.use require './router'

app.use (err, req, res, next) ->
  console.error err.stack
  res.status err.status or 500
  res.end()

server = app.listen 8080, -> console.log 'Listening on port 8080'

