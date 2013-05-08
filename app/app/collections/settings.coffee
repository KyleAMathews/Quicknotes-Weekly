Setting = require 'models/setting'

module.exports = class Settings extends Backbone.Collection

  url: '/settings'
  model: Setting
