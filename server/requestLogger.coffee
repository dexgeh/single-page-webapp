
http = require 'http'

module.exports = (req, res, next) ->
  res._logging = {}
  res._logging.method = req.method
  res._logging.url = req.url
  res._logging.startTime = Date.now()
  res._logging.ip = req.ip
  next()

writeHead = http.ServerResponse.prototype.writeHead
# response.writeHead(statusCode, [reasonPhrase], [headers])
http.ServerResponse.prototype.writeHead = (statusCode, reasonPhrase, headers) ->
  writeHead.apply this, arguments
  if @_logging
    @_logging.statusCode = statusCode

end = http.ServerResponse.prototype.end
# response.end([data], [encoding])
http.ServerResponse.prototype.end = (data, encoding) ->
  end.apply this, arguments
  if @_logging
    logRecord = "#{@_logging.ip} #{Date.now()-@_logging.startTime} #{@_logging.statusCode} #{@_logging.method} #{@_logging.url}"
    console.log logRecord

