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
    # TODO- REPLACE WITH COLLAB OPPS
    message = """
    This is the broadcast message
    - Includng some bullet points...
    - ... and New lines
    """

    for room in rooms
      robot.messageRoom room, message

  #
  # Event Configurations
  #

  new cronJob('0 0 10 * * 4', tz, broadcast) # Thursdays @ 10am
