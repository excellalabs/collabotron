# Description:
#   Defines periodic executions
#

module.exports = (robot) ->
  cronJob = require('hubot-cronjob')
  tz = 'America/New_York'
  rooms = ['collabotron-dev']

  #
  # Event Handler Functions
  #

  broadcast = ->
    projects = robot.brain.get 'projects'
    message = """
    This is the broadcast message:
    - I have #{projects.length} projects stored.
    Beep boop.
    """

    for room in rooms
      robot.messageRoom room, message

  #
  # Event Configurations
  #

  # new cronJob('0 0 10 * * 4', tz, broadcast) # Thursdays @ 10am
