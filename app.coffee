# Module dependencies.

express = require('express')
sendEmail = require('./sendEmail').sendEmail

app = module.exports = express.createServer()

# Configuration

app.configure ->
  app.set('views', __dirname + '/views')
  app.set('view engine', 'jade')
  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.use(app.router)
  app.use(express.static(__dirname + '/public'))

app.configure 'development', ->
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }))

app.configure 'production', ->
  app.use(express.errorHandler())

app.get '/', (request, response) ->
    response.send('Hello World!')

port = process.env.PORT || 3000
app.listen port, ->
  console.log("Listening on " + port)
