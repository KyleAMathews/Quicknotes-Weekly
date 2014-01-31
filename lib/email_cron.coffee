cronJob = require('cron').CronJob
moment = require "moment"
_ = require ('underscore')

config = require '../config'
mailgun = require('./sendEmail')
settings = require('./settings')

QNoteKey = "gsmathews"

# Query Mongo for the next two questions.
getNextTwoQuestions = (callback) ->
  Question = config.mongoose.model 'question'
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
    # Log the error and quit.
    if err
      console.log err
      return callback(false)

    emailBody = """
      <p><strong>QuickNotes Weekly</strong> for #{ date }</p>
      <ul>
      <li>What are three highlights from this past week (feel free to write more, if you so wish)?</li>\n
      """
    if questions.length > 0
      for question in questions
        emailBody += "<li>#{ question.question }</li>\n"
      emailBody += "</ul>"
    else
      emailBody += "</ul><p><em>Oh noes! There weren't any questions added to Quicknotes this week</p>"

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
nextRun.add('ms', job.cronTime.getTimeout())
console.log 'this job will next run ' +  nextRun.fromNow()
#_.delay sendEmails, 3000

module.exports = sendEmails
