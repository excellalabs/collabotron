
common = require('./common.coffee')

module.exports = (robot) ->

  robot.hear /collabotron test/i, (res) ->
    res.send "Beep boop. I'm collabotron."

  # Auto threading
  robot.hear /thread (.*) here/i, (res) ->
    res.message.thread_ts = res.message.rawMessage.ts
    res.send ':thread:'

  #
  # Cosplay as HAL, from `2001, A Space Odyssey`
  #

  robot.respond /open the (.*) doors/i, (res) ->
    doorType = res.match[1]
    if doorType is "pod bay"
      res.reply "I'm afraid I can't do that."
    else
      res.reply "Opening #{doorType} doors"

  #
  # Handle new entries
  #
  robot.hear common.templateIndicator, (res) ->
    # We're always replying in thread, here.
    res.message.thread_ts = res.message.rawMessage.ts

    # strip formatting (* or _)
    unformatted = res.match[0].replace /\*|_/g, ''

    # If it matches the template
    if common.template.exec unformatted
      parsed = unformatted.match common.template
      res.send ":thread: Please discuss collaborating on this `#{parsed.groups.type}` here!"

    # If it doesn't match our template
    else
      res.send "Beep boop. Sorry, I couldn't parse this. Please use the pinned template. Thanks!"
      console.log unformatted

  #
  # ENTER / LEAVE CHANNEL REPLIES
  #

  # enterReplies = ['Hi', 'Target Acquired', 'Hello friend.', 'Welcome', 'Grab a seat']
  # leaveReplies = ['Are you still there?', 'Yay! :yay:', 'Woohoo! :ablobdance:']

  #   robot.enter (res) ->
  #     res.send res.random enterReplies


  #
  #  ERROR HANDLING
  #

  robot.error (err, res) ->
    robot.logger.error "DOES NOT COMPUTE"

    if res?
      res.reply "DOES NOT COMPUTE"

