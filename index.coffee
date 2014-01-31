express = require('express')

require('./lib/question_schema')
require('./lib/setting_schema')
sendEmail = require('./lib/email_cron')
require('./lib/settings')

questions_routes = require('./routes/questions')
settings_routes = require('./routes/settings')

app = express()

# Configure Express.
app.configure ->
  app.set('port', process.env.PORT || 3000)
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

app.get '/settings', settings_routes.getSettings
app.put '/settings/:id', settings_routes.putSetting
app.post '/settings', settings_routes.postSettings
app.delete '/settings/:id', settings_routes.deleteSetting
app.post '/send-email', (req, res) ->
  sendEmail()
  res.send 'ok'



# Start the express server.
app.listen app.get('port'), ->
  console.log("Listening on " + app.get('port'))
