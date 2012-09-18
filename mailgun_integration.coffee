module.exports = (req, res) ->
  try
    headers = JSON.parse req.body['message-headers']
  catch error
    console.log error
  message_id = ""
  references = ""
  in_reply_to = ""
  subject = ""
  for header in headers
    switch header[0]
      when 'Message-Id' then message_id = header[1]
      when 'In-Reply-To' then in_reply_to = header[1]
      when 'References' then references = header[1]
      when 'Subject' then subject = header[1]
  # Save to set for this group, key is the reference header from the email.
  if in_reply_to.length > 0
    quicknote_id = in_reply_to.split('@').shift().substr(1) # split, shift, remove <
    account = quicknote_id.split('==').shift()

    rclient.hset(quicknote_id, req.body.from, JSON.stringify(req.body), redis.print)

    # Send on email to other group members.
    sendEmail(responseEmail, req.body.from, subject, req.body['body-html'],
      message_id, in_reply_to, references )
  res.send 'ok'
