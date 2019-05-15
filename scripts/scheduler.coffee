# Description:
#   Defines periodic executions
#

module.exports = (robot) ->
  cronJob = require('hubot-cronjob')
  tz = 'America/New_York'
  room = 'benchbot-dev'

  #
  # Event Handler Functions
  #

  dailyBlockers = ->
    robot.messageRoom room, '@here Are you blocked by anything?  Are you looking to pair-program? Remember to radiate questions and problems, we\'re all in this together!'

  virtualStandup = ->
    robot.messageRoom room, '@here It\'s time for our virtual standup.  What are you working on that you need halp with, and if you\'re free, what would you like to work on?'

  sprintPlanningReminder = ->
    robot.messageRoom room, '@here Reminder: Sprint Planning begins shortly!'

  retrospectiveReminder = ->
    robot.messageRoom room, '@here Reminder: Retrospective begins in just a few minutes!'

  timesheetReminder = ->
    robot.messageRoom room, '@here Don\'t forget to update your timesheet!'

  #
  # Event Configurations
  #

  new cronJob('0 55 9 * * 1', tz, retrospectiveReminder)  # Mondays @ 9:55am
  new cronJob('0 0 10 * * 2', tz, dailyBlockers)          # Tuesdays @ 10am
  new cronJob('0 55 9 * * 2', tz, sprintPlanningReminder) # Wednesdays @ 9:55am
  new cronJob('0 0 10 * * 4', tz, dailyBlockers)          # Thursdays @ 10am
  new cronJob('0 0 10 * * 2', tz, virtualStandup)         # Fridays @ 10am
  new cronJob('0 0 16 * * 1-5', tz, timesheetReminder)    # Weekdays @ 4pm
