mongo_url = process.env.MONGO_URL ?  "mongodb://localhost/quicknotes"
mongoose = require('mongoose')
mongoose.connect(mongo_url)

# Setup MongoDB schemas.
Schema = mongoose.Schema

QuestionSchema = new Schema (
  question: { type: String }
  created: { type: Date, default: new Date() }
  sent: { type: Date, default: null }
  order: { type: Number, default: 1000 }
)

mongoose.model 'question', QuestionSchema
