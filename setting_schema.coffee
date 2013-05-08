mongoose = require('mongoose')

# Setup MongoDB schemas.
Schema = mongoose.Schema

SettingSchema = new Schema (
  name: { type: String }
  value: { type: String }
)

mongoose.model 'setting', SettingSchema

