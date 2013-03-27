mongoose = require('mongoose')
if process.env.NODE_ENV is 'production'
  mongoose.createConnection(process.env.MONGOLAB_URI)
else
  mongoose.createConnection(process.env.MONGO_CONNECT)

# Setup MongoDB schemas.
Schema = mongoose.Schema

QuestionSchema = new Schema (
  question: { type: String }
  created: { type: Date, default: new Date() }
  sent: { type: Date, default: null }
  order: { type: Number, default: 1000 }
)

mongoose.model 'question', QuestionSchema
