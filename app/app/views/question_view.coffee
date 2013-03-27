module.exports = class QuestionView extends Backbone.View

  tagName: 'li'

  initialize: ->
    @listenTo @model, 'all', @render
    @listenTo @model, 'destroy', @destroy

  events:
    'dblclick': 'editMode'
    'click button.save-question': 'saveQuestion'
    'click button.delete-question': 'deleteQuestion'

  render: ->
    @mode = 'normal'
    @$el.html @model.get('question')
    @$el.data('id', @model.id)

    @

  renderDblClick: ->
    @mode = 'edit'
    @$el.html "<div class='edit-mode'>
      <input value='#{ @model.get('question') }' />
      <button class='save-question'>Save</button><button class='delete-question'>Delete Question</button>
      </div>
      "

  editMode: ->
    if @mode is "normal"
      @renderDblClick()

  saveQuestion: ->
    newQuestion = @$('input').val()
    @model.save question: newQuestion
    @render()

  deleteQuestion: ->
    @model.destroy()

  destroy: ->
    @remove()
