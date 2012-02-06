# Module dependencies.

express = require('express')
sendEmail = require('./sendEmail').sendEmail
redis = require('redis')
rclient = redis.createClient()

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

app.get '/', (req, res) ->
  res.send('Hello World!')

app.post '/mailgun', (req, res) ->
  console.log JSON.stringify(req.body)
  # save email info to redis into a set? one set per quicknote?
  rclient.hset('quicknotes-testing', req.body['Message-Id'], JSON.stringify(req.body), redis.print)
  res.send 'ok'

app.get '/email_responses', (req, res) ->
  # retch all emails and spit out
  rclient.hgetall 'quicknotes-testing', (err, emails) ->
    res.json emails


port = process.env.PORT || 3000
app.listen port, ->
  console.log("Listening on " + port)
