module.exports = class QuestionView extends Backbone.View

  tagName: 'li'

  initialize: ->
    @listenTo @model, 'all', @render

  render: ->
    @$el.html @model.get('question')
    @$el.data('id', @model.id)

    @
