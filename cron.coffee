cronJob = require('cron').CronJob
moment = require "moment"
job = new cronJob
  cronTime: '00 00 20 * * 6' # Run every Friday at 8pm MST (server is set to Utah time).
  #cronTime: '* 10 22 * * 0' # Run every Friday at 8pm.
  onTick: -> console.log 'You will see this message every three seconds'
  start: true

job.start()

nextRun = moment()
#console.log job.cronTime
console.log nextRun.add('ms', job.cronTime.getTimeout())
console.log 'this job will next run ' +  nextRun.fromNow()
