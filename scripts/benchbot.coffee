module.exports = (robot) ->
  robot.hear /benchbot test/i, (res) ->
    res.send "It's working."

  robot.hear /livin([g]?) the dream/i, (res) ->
    res.reply "Wake up!"

  #
  # 2001
  #

  robot.respond /open the (.*) doors/i, (res) ->
    doorType = res.match[1]
    if doorType is "pod bay"
      res.reply "I'm afraid I can't let you do that."
    else
      res.reply "Opening #{doorType} doors"

  #
  # ENTER / LEAVE CHANNEL REPLIES
  #

  enterReplies = ['Hi', 'Target Acquired', 'Hello friend.', 'Welcome', 'Grab a seat']
  leaveReplies = ['Are you still there?', 'Yay! :yay:', 'Woohoo! :ablobdance:']

  robot.enter (res) ->
    res.send res.random enterReplies
    robot.messageRoom res.envelope.user.name "Welcome to the Bench!"

  robot.leave (res) ->
    res.send res.random leaveReplies

  #
  #  ERROR HANDLING
  #

  robot.error (err, res) ->
    robot.logger.error "DOES NOT COMPUTE"

    if res?
      res.reply "DOES NOT COMPUTE"

