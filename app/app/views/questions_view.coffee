QuestionsTemplate = require 'views/templates/questions'
QuestionView = require 'views/question_view'

module.exports = class QuestionsView extends Backbone.View

  id: 'questions-view'

  initialize: ->
    @listenTo @collection, 'sync reset', @render

  events:
    'click button.add-question': 'addQuestion'
    'keypress input.new-question': 'keypressHandler'

  render: ->
    @$el.html QuestionsTemplate()

    for question in @collection.notSent()
      questionView = @addChildView new QuestionView(
        model: question
      )
      @$('ul.questions').append questionView.render().el

    @$('ul').off()
    @$('ul').sortable()
    @$('ul').on('sortupdate', => @saveNewOrder())

    _.defer =>
      @$('input.new-question').focus()

    @

  keypressHandler:(e) ->
    if e.which is 13 then @addQuestion()

  addQuestion: ->
    question = @$('input.new-question').val()
    @collection.create question: question, order: @collection.length

  saveNewOrder: ->
    ids = []
    @$('ul li').each (index, result) =>
       ids.push $(result).data('id')

    for id, index in ids
      @collection.get(id).save('order', index)

    @collection.sort()
