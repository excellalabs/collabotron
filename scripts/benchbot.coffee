module.exports = (robot) ->

  robot.hear /benchbot test/i, (res) ->
    res.send "It's working."

  robot.hear /livin([g]?) the dream/i, (res) ->
    res.reply "Wake up!"

  robot.respond /brunch/i, (res) ->
    breakfast = ['pancakes', 'waffles', 'an omelete', 'a breakfast burrito']
    res.reply "Order me " + res.random(breakfast) + ", please!"

  # Auto threading
  robot.hear /thread (.*) here/i, (res) ->
    res.message.thread_ts = res.message.rawMessage.ts
    res.send ':thread:'

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

  # enterReplies = ['Hi', 'Target Acquired', 'Hello friend.', 'Welcome', 'Grab a seat']
  # leaveReplies = ['Are you still there?', 'Yay! :yay:', 'Woohoo! :ablobdance:']

#   robot.enter (res) ->
#     res.send res.random enterReplies
#     benchWelcomeMessage = """
# 🤠 Howdy, I'm benchbot. Welcome to the bench!

# Here's what you need to know:
# 1) Update your Excella-templated resume and upload it to Sharepoint
# 2) Please add yourself to the bench email distribution list if you aren't already there
# 3) Read more about these steps and other Bench related stuffs on the bench Portal, here: https://excellaco.sharepoint.com/sites/Services/SitePages/Bench-Portal.aspx?web=1
# """
    # robot.messageRoom(res.envelope.user.id, benchWelcomeMessage)

#   robot.leave (res) ->
#     res.send res.random leaveReplies
#     benchDepartureMessage = """ We're sorry to see you leave the bench!
# Please make sure you've closed or otherwise passed off any LeanKit tickets to someone else on the bench.
# Best of luck on your next project!
# """
    # robot.messageRoom(res.envelope.user.id, benchDepartureMessage)

  #
  #  ERROR HANDLING
  #

  robot.error (err, res) ->
    robot.logger.error "DOES NOT COMPUTE"

    if res?
      res.reply "DOES NOT COMPUTE"

