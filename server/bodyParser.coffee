qs = require 'querystring'

read = (req, next) ->
  chunks = []
  req.on 'data', (data) -> chunks.push data
  req.on 'end', ->
    body = chunks.map (c) ->
      c.toString 'utf8'
    .join ''
    next body

module.exports = (req, res, next) ->
  if req.is 'application/x-www-form-urlencoded'
    read req, (body) ->
      req.body = qs.parse body
      next()
  else if req.is 'application/json'
    read req, (body) ->
      try
        req.body = JSON.parse body
        next()
      catch e
        next e
  else
    next()

