Questions = require 'collections/questions'
Settings = require 'collections/settings'

# Application bootstrapper.
module.exports = Application =
  initialize: ->
    Router = require('router')
    @router = new Router()

    @collections = {}
    @collections.questions = new Questions()
    @collections.questions.fetch()
    @collections.settings = new Settings()
    @collections.settings.fetch()


    # Add an eventBus for inter-module communications.
    @eventBus = _.extend({}, Backbone.Events)
    # Optional debug line. Helps with tracking when things happen.
    @eventBus.on 'all', (eventName, args) -> console.log 'new event on the eventBus: ' + eventName

window.app = Application
