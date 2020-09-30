# Description:
#   Defines periodic executions
#

module.exports = (robot) ->
  common = require('./common.coffee')
  cronJob = require('hubot-cronjob')
  tz = 'America/New_York'
  testRooms = ['collabotron-dev']
  rooms = ["general", "bench", "software-development", "innovation"]

  #
  # Event Handler Functions
  #

  broadcast = ->
    for room in rooms
      common.listProjects robot, room


  testBroadcast = ->
    for room in testRooms
      common.listProjects robot, room

  #
  # Event Configurations
  #

  new cronJob('0 0 10 * * 4', tz, broadcast) # Thursdays @ 10am
  new cronJob('0 0 15 * * 3', tz, testBroadcast) # Wednesdays @ 3pm
