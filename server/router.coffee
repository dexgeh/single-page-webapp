path = require 'path'
fs = require 'fs'

express = require 'express'

page = (data, next) ->
  if page.content
    if not data
      data = {}
    next null, page.content.replace /{init}/, JSON.stringify data
  else
    fs.readFile path.join(process.cwd(), 'page.html'), 'utf8', (err, content) ->
      return next err if err
      page.content = content
      page data, next

sendPage = (data, status=200, res, req, next) ->
  page data, (err, body) ->
    return next err if err
    res.writeHead status,
      'Content-Type':'text/html; charset=UTF-8'
    res.end body

sendEmptyPage = (status=200, req, res, next) ->
  if sendEmptyPage.content
    res.writeHead status,
      'Content-Type':'text/html; charset=UTF-8'
    res.end sendEmptyPage.content
  else
    page null, (err, body) ->
      return next err if err
      sendEmptyPage.content = body
      sendEmptyPage status, req, res, next

router = express.Router()
router.get '/', sendEmptyPage.bind null, 200
router.get '/about', sendEmptyPage.bind null, 200

router.get '*', (req, res, next) ->
  sendEmptyPage 404, req, res, next

module.exports = router
