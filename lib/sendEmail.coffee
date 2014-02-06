request = require('request')
querystring = require('querystring')
url = require('url')

mailgun_uri = url.parse("https://api.mailgun.net/v2/#{ process.env.MAILGUN_DOMAIN }/messages")
mailgun_uri.auth = "api:" + process.env.MAILGUN_API_KEY

exports.sendEmail = (to, from, subject, body, message_id, in_reply_to = null, references = null) ->
  unless message_id? then return false
  email =
      from: from
      to: to
      subject: subject
      html: body

  email['h:Message-Id'] = message_id
  if in_reply_to?
    email['h:In-Reply-To'] = in_reply_to
  if references?
    email['h:References'] = references

  email = querystring.stringify(email)

  request(
    url: mailgun_uri
    method: 'POST'
    headers:
      'content-type': 'application/x-www-form-urlencoded'
    body: email
    (error, response, body) ->
      if error then console.log error
      console.log response.statusCode
      console.log body
  )
