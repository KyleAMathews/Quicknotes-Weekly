mongoose = require('mongoose')
mongoose.createConnection('mongodb://localhost/quicknotes')

# Setup MongoDB schemas.
Schema = mongoose.Schema

QuestionSchema = new Schema (
  question: { type: String }
  order: { type: Number }
)

mongoose.model 'question', QuestionSchema
