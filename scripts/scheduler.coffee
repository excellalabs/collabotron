# Description:
#   Defines periodic executions
#
# https://leanpub.com/automation-and-monitoring-with-hubot/read#leanpub-auto-periodic-task-execution
#

module.exports = (robot) ->
  cronJob = require('hubot-cronjob')
  tz = 'America/New_York'
  new cronJob('0 0 10 * * 1-5', tz, workdaysTenAm)
  new cronJob('10 15 * * * 1-5', tz, workdaysThreePm)
  new cronJob('*/5 * * * * *', tz, everyFiveMinutes)
  new cronJob('* * * * * *', tz, everySecond)

  room = 'benchbot-dev'

  workdaysTenAm = ->
    robot.messageRoom room, ''

  workdaysThreePm = ->
    robot.messageRoom room, 'This is a test for a daily reminder at 3pm.  Update your timesheets!'

  everyFiveMinutes = ->
    robot.messageRoom room, 'I will nag you every 5 minutes'

  everySecond = ->
    console.log('second ping = win')
