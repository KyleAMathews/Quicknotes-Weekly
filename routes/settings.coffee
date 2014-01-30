config = require '../config'

# Get settings page.

exports.getSettings = (req, res) ->
  Setting = config.mongoose.model 'setting'
  Setting.find()
    .exec (err, settings) ->
      for setting in settings
        setting.setValue('id', setting.getValue('_id'))
      res.json settings

exports.putSetting = (req, res) ->
  Setting = config.mongoose.model 'setting'
  Setting.findById(req.params.id, (err, result) ->
    for k,v of req.body
      result[k] = v
    result.save (err) ->
      unless err
        res.json 'ok'
      else
        console.log err
  )

exports.postSettings = (req, res) ->
  Setting = config.mongoose.model 'setting'
  newSetting = Setting()
  for k,v of req.body
    newSetting[k] = v
  newSetting.save (err) ->
    unless err
      res.json { id: newSetting['_id'], created: newSetting.created }
    else
      console.log err
      res.json 500, { message: "Post wasn't saved correctly", error: err }

exports.deleteSetting = (req, res) ->
  Setting = config.mongoose.model 'setting'
  Setting.findById(req.params.id, (err, result) ->
    result.remove (err, result) ->
      unless err
        res.json 'ok'
      else
        console.log err
        res.json 500, 'setting was not deleted correctly'
  )

