SettingsTemplate = require './templates/settings'

module.exports = class SettingsView extends Backbone.View

  events:
    'submit': 'submit'

  initialize: ->
    @listenTo @collection, 'sync add', @render

  render: ->
    @$el.html SettingsTemplate collection: @collection
    @

  submit: (e) ->
    e.preventDefault()
    to = @$('.js-to').val()
    from = @$('.js-from').val()

    @collection.getByName('to_address').save('value', to)
    @collection.getByName('from_address').save('value', from)
