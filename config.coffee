EventEmitter = require('events').EventEmitter
config = new EventEmitter()

# MongoDb
config.mongoose = require('mongoose')
if process.env.MONGOHQ_URL?
  config.mongo_url = process.env.MONGOHQ_URL
else if process.env.QUICKNOTESWEEKLY_DB_1_PORT?
  config.mongo_url = "mongodb://#{ process.env.QUICKNOTESWEEKLY_DB_1_PORT_27017_TCP_ADDR }:#{ process.env.QUICKNOTESWEEKLY_DB_1_PORT }/quicknotes"
else
 config.mongo_url = "mongodb://127.0.0.1:27017/quicknotes"

config.mongoose.connect(config.mongo_url)

module.exports = config
