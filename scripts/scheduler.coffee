# Description:
#   Defines periodic executions
#
# https://leanpub.com/automation-and-monitoring-with-hubot/read#leanpub-auto-periodic-task-execution
#

module.exports = (robot) ->
  cronJob = require('cron').CronJob
  tz = 'America/New_York'
  new cronJob('0 0 10 * * 1-5', workdaysTenAm, null, true, tz)
  new cronJob('0 0 15 * * 1-5', workdaysThreePm, null, true, tz)
  new cronJob('0 */5  * * * *', everyFiveMinutes, null, true, tz)

  room = 'benchbot-dev'

  workdaysTenAm = ->
    robot.messageRoom room, ''

  workdaysThreePm = ->
    robot.messageRoom room, 'This is a test for a daily reminder at 3pm.  Update your timesheets!'

  everyFiveMinutes = ->
    robot.messageRoom room, 'I will nag you every 5 minutes'
