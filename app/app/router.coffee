QuestionsView = require('views/questions_view')

module.exports = class Router extends Backbone.Router

  routes:
    '': 'questions'

  questions: ->
    questionsView = new QuestionsView collection: app.collections.questions
    $('body').html questionsView.render().el
