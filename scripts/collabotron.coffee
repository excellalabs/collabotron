common = require('./common.coffee')

module.exports = (robot) ->

  robot.hear /collabotron test/i, (res) ->
    res.send "Beep boop. I'm collabotron.  Everything looks good, @#{res.message.user.name} ."

  #
  # Auto threading
  #
  robot.hear /thread (.*) here/i, (res) ->
    if !res.message.thread_ts
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
    if !res.message.thread_ts
      res.message.thread_ts = res.message.rawMessage.ts

    # strip formatting (* or _)
    unformatted = res.message.text.replace /\*|_/g, ''

    # If it matches the template
    if common.template.exec unformatted
      parsed = unformatted.match common.template
      res.send ":thread: Please discuss collaborating on this `#{parsed.groups.type}` here!"

      # Create a new project for tracking
      newProject = {
        owner: res.message.user.name,
        description: parsed.groups.description,
        type: parsed.groups.type,
        url: "https://excella.slack.com/archives/#{res.message.room}/p#{res.message.id.replace /\./g, ''}"
      }

      # Prep the storage space in the brain, if it's not ready
      if !robot.brain.get 'projects'
        robot.brain.set 'projects', []

      # Remember the project
      projects = robot.brain.get 'projects'
      projects.push newProject
      robot.brain.set 'projects', projects

    # If it doesn't match our template
    else
      res.send "Beep boop. Sorry, I couldn't parse this. Please use the pinned template. Thanks!"
      console.log unformatted

  #
  # Report on status of project tracking
  #
  robot.hear /collabotron status/i, (res) ->
    projects = robot.brain.get 'projects'
    if !projects
      projects = []
    res.send "Beep boop.  I am currently tracking #{projects.length} projects!"

  #
  # List tracked projects
  #
  robot.hear /collabotron list/i, (res) ->
    projects = robot.brain.get 'projects'
    if !projects.length
      robot.brain.set 'projects', []
    message = "Beep boop.\nListing #{projects.length} projects:\n"

    projects.forEach (project, i) ->
      message += "\n#{i + 1}. A *#{project.type}* by @#{project.owner}, <#{project.url}|here>"

    res.send message

  #
  # Purge all tracked projects
  #
  robot.hear /collabotron purge(,?\splease)?/i, (res) ->
    if !res.message.thread_ts
        res.message.thread_ts = res.message.rawMessage.ts

    if !res.match[1]
      res.send "Ah, ah, ah!  You didn't say the magic word!"
    else
      projects = robot.brain.get 'projects'
      if projects.length
        robot.brain.set 'projects', []
        res.send "Well, since you said please...\nProjects purged."
      else
        res.send "Nothing to purge, boss.  But, thanks for asking nicely!"

  #
  # Delete a specific project
  #
  robot.hear /collabotron delete (\d+)(,?\splease)?/i, (res) ->
    if !res.message.thread_ts
        res.message.thread_ts = res.message.rawMessage.ts

    if !res.match[2]
      res.send "Ah, ah, ah!  You didn't say the magic word!"
    else
      projects = robot.brain.get 'projects'
      # Fault tolerance for empty database
      if !projects.length
        projects = []
        robot.brain.set 'projects', []
      # Falut tolerance for out of bounds (high)
      if res.match[1] > projects.length
        res.send "No can do, I only have #{projects.length} projects."
      else
        projects.splice res.match[1] - 1, 1  # account for 0-indexing of arrays
        res.send "Done!  Check the list now, boss."

  #
  #  ERROR HANDLING
  #
  robot.error (err, res) ->
    robot.logger.error "DOES NOT COMPUTE"

    if res?
      res.reply "DOES NOT COMPUTE"

