Setting = require 'models/setting'

module.exports = class Settings extends Backbone.Collection

  url: '/settings'
  model: Setting

  initialize: ->
    @listenTo @, 'sync', ->
      unless @getByName('to_address')? or @getByName('from_address')? and @length > 2
        @create {
          name: 'from_address'
          value: ''
        }
        @create {
          name: 'to_address'
          value: ''
        }

  getByName: (name) ->
    @find (model) -> model.get('name') is name
