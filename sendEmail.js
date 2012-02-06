(function() {
  var mailgun_uri, querystring, request, url;
  request = require('request');
  querystring = require('querystring');
  url = require('url');
  mailgun_uri = url.parse('https://api.mailgun.net/v2/kyle.mailgun.org/messages');
  mailgun_uri.auth = 'api:key-4efruk6kp1y6nrafq7zhpoipbpmtv476';
  exports.sendEmail = function(to, from, subject, body) {
    var email;
    email = querystring.stringify({
      from: from,
      to: to,
      subject: subject,
      text: body
    });
    console.log(body);
    return request({
      url: mailgun_uri,
      method: 'POST',
      headers: {
        'content-type': 'application/x-www-form-urlencoded'
      },
      body: email
    }, function(error, response, body) {
      console.log(response.statusCode);
      return console.log(body);
    });
  };
}).call(this);
