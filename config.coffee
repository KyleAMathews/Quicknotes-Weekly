EventEmitter = require('events').EventEmitter
config = new EventEmitter()

# MongoDb
config.mongoose = require('mongoose')
config.mongo_url = process.env.MONGOHQ_URL || "mongodb://127.0.0.1:27017/quicknotes"
config.mongoose.connect(config.mongo_url)

module.exports = config
