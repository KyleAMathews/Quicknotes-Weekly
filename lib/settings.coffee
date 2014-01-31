config = require '../config'

Setting = config.mongoose.model 'setting'
Setting.find()
  .exec (err, settings) ->
    for setting in settings
      module.exports[setting['name']] = setting['value']
