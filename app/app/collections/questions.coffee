Question = require 'models/question'

module.exports = class Questions extends Backbone.Collection

  url: '/questions'
  model: Question

  comparator: (question) ->
    return question.get('order')

  notSent: ->
    return @filter (question) -> return not question.get('sent')?
