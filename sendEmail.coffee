request = require('request')
querystring = require('querystring')
url = require('url')
mailgun_uri = url.parse('https://api.mailgun.net/v2/kyle.mailgun.org/messages')
mailgun_uri.auth = 'api:key-4efruk6kp1y6nrafq7zhpoipbpmtv476'

exports.sendEmail = (to, from, subject, body) ->
  email = querystring.stringify(
      from: from
      to: to
      subject: subject
      text: body
    )

  console.log body

  request(
    url: mailgun_uri
    method: 'POST'
    headers:
      'content-type': 'application/x-www-form-urlencoded'
    body: email
    (error, response, body) ->
      console.log response.statusCode
      console.log body
  )
