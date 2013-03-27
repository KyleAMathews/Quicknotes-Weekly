mongoose = require('mongoose')
db = mongoose.createConnection('mongodb://localhost/quicknotes')

# Get questions page.

exports.getQuestions = (req, res) ->
  Question = db.model 'question'
  Question.find()
    .sort('order')
    .exec (err, questions) ->
      for question in questions
        question.setValue('id', question.getValue('_id'))
      res.json questions

exports.putQuestion = (req, res) ->
  Question = db.model 'question'
  Question.findById(req.params.id, (err, result) ->
    for k,v of req.body
      result[k] = v
    result.save (err) ->
      unless err
        res.json 'ok'
      else
        console.log err
  )

exports.postQuestions = (req, res) ->
  Question = db.model 'question'
  # TODO rewrite using asyns.js so question
  # value the same (or is there some other way?)
  newQuestion = Question()
  for k,v of req.body
    newQuestion[k] = v
  newQuestion.save (err) ->
    unless err
      res.json { id: newQuestion['_id'], created: newQuestion.created }
    else
      console.log err
      res.json 500, { message: "Post wasn't saved correctly", error: err }

exports.deleteQuestion = (req, res) ->
  Question = db.model 'question'
  Question.findById(req.params.id, (err, result) ->
    result.remove (err, result) ->
      unless err
        res.json 'ok'
      else
        console.log err
        res.json 500, 'question was not deleted correctly'
  )
