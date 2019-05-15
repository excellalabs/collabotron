# Description:
#   Defines periodic executions
#
# https://leanpub.com/automation-and-monitoring-with-hubot/read#leanpub-auto-periodic-task-execution
#

module.exports = (robot) ->
  cronJob = require('cron').CronJob
  tz = 'America/New_York'
  new cronJob('0 0 10 * * 1-5', workdaysTenAm, null, true, tz)
  new cronJob('*/5 * * * * *', everyFiveSeconds, null, true, tz)

  room = 'bench'

  workdaysTenAm = ->
    robot.messageRoom room, ''

  everyFiveSeconds = ->
    robot.messageRoom room, 'I will nag you every 5 minutes'
