# Module dependencies.
require('./question_schema')
express = require('express')
require('./email_cron')

questions_routes = require('./routes/questions')

app = express()

# Configure Express.
app.configure ->
  app.set('views', __dirname + '/views')
  app.set('view engine', 'jade')
  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.use(app.router)
  app.use(express.static(__dirname + '/app/public'))

app.configure 'development', ->
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }))

app.configure 'production', ->
  app.use(express.errorHandler())

# API for admin api.
app.get '/questions', questions_routes.getQuestions
app.put '/questions/:id', questions_routes.putQuestion
app.post '/questions', questions_routes.postQuestions
app.delete '/questions/:id', questions_routes.deleteQuestion

# Start the express server.
port = process.env.PORT || 3000
app.listen port, ->
  console.log("Listening on " + port)
