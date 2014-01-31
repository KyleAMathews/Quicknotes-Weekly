config = require '../config'

# Setup MongoDB schemas.
Schema = config.mongoose.Schema

SettingSchema = new Schema (
  name: { type: String }
  value: { type: String }
)

config.mongoose.model 'setting', SettingSchema

