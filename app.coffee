# Module dependencies.
express = require('express')
sendEmail = require('./sendEmail').sendEmail
mailgunIntegration = require('./mailgun_integration')
require('./email_cron')
redis = require('redis')
rclient = redis.createClient()

questions_routes = require('./routes/questions')

app = express()

# Configure Express.
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

# TODO this should launch the backbone admin ui
app.get '/', (req, res) ->
  res.render('questions')

# API for admin api.
app.get '/questions', questions_routes.getQuestions
app.put '/questions', questions_routes.putQuestions
app.post '/questions', questions_routes.postQuestions

# Respond to incoming emails from Mailgun.
app.post '/mailgun', mailgunIntegration

# Start the express server.
port = process.env.PORT || 3000
app.listen port, ->
  console.log("Listening on " + port)

