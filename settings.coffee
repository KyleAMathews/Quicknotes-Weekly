mongoose = require('mongoose')
Setting = mongoose.model 'setting'
Setting.find()
  .exec (err, settings) ->
    for setting in settings
      module.exports[setting['name']] = setting['value']
