config = require '../config'

# Setup MongoDB schemas.
Schema = config.mongoose.Schema

QuestionSchema = new Schema (
  question: { type: String }
  created: { type: Date, default: new Date() }
  sent: { type: Date, default: null }
  order: { type: Number, default: 1000 }
)

config.mongoose.model 'question', QuestionSchema
