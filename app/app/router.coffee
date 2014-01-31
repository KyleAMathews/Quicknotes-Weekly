QuestionsView = require('views/questions_view')
SettingsView = require('views/settings_view')
MainTemplate = require 'views/templates/main'

module.exports = class Router extends Backbone.Router

  routes:
    '': 'main'

  main: ->
    questionsView = new QuestionsView collection: app.collections.questions
    $('body').html MainTemplate()
    $('#questions').html questionsView.render().el
    $('#settings').html new SettingsView(collection: app.collections.settings).render().el
