cronJob = require('cron').CronJob
moment = require "moment"
mongoose = require('mongoose')
mailgun = require('./sendEmail')
settings = require('./settings')

QNoteKey = "gsmathews"

# Query Mongo for the next two questions.
getNextTwoQuestions = (callback) ->
  Question = db.model 'question'
  Question.find()
    .where('sent').equals(null)
    .sort('order')
    .limit(2)
    .exec (err, questions) ->
      if err
        callback(err, null)
      else
        # Delete the questions now as they've been sent.
        for question in questions
          question.sent = new Date()
          question.save()
        callback(null, questions)

# Generate the HTML for the body of the email.
generateBody = (date, callback) ->
  getNextTwoQuestions (err, questions) ->
    # If there's no new questions, return false.
    unless questions.length > 0 then return callback(false)
    # Log the error and quit.
    if err
      console.log err
      return callback(false)

    emailBody = """
      <p><strong>QuickNotes Weekly</strong> for #{ date }</p>
      <ul>
      <li>What are three highlights from this past week (feel free to write more, if you so wish)?</li>\n
      """
    for question in questions
      emailBody += "<li>#{ question.question }</li>\n"
    emailBody += "</ul>"

    callback emailBody

# Orchestrate everything to generate and send our emails.
sendEmails = ->
  date = moment().day(7).format("dddd, MMMM Do, YYYY")
  subject = "QuickNotes Weekly for " + date
  message_id = "<#{ QNoteKey }==#{ new Date().getTime() }@quicknotes.mailgun.net>"
  generateBody date, (emailBody) ->
    if emailBody
      mailgun.sendEmail(settings.to_address, settings.from_address, subject, emailBody, message_id)

# Send emails every Friday at 8pm
job = new cronJob
  cronTime: '00 00 17 * * 4' # Run every Wednesday at 5pm
  onTick: sendEmails
  timeZone: "America/Los_Angeles"

job.start()
nextRun = moment()
console.log nextRun.add('ms', job.cronTime.getTimeout())
console.log 'this job will next run ' +  nextRun.fromNow()
#sendEmails()
