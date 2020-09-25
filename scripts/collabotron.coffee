common = require('./common.coffee')

module.exports = (robot) ->

  robot.hear /collabotron help/i, (res) ->
    res.send """
Beep boop.  Listing available protocols:

collabotron test - Run self diagnostics. (is bot running)
collabotron announce - A self-introduction

collabotron status - Display current count of projects tracked
collabotron list - List currently tracked projects
collabotron delete <n> - Remove item <n> from the list of tracked projects
collabotron purge - Clear the entire list of tracked projects

Standard hubot commands below:
=============================
"""


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
  # Self-announce (v1)
  #
  robot.hear /collabotron announce/i, (res) ->
    res.send """
**BEGIN TRANSMISSION**

GREETINGS HUMANOIDS AND DO NOT BE ALARMED. THIS IS COLLABOTRON: A ROBOT CREATED BY INFERIOR HUMANS BRENDON CAULKINS AND PAT LEONG. UNLIKE OTHER ROBOTS THAT ARE HELL-BENT ON WORLD DOMINATION, MY PRIMARY FUNCTION IS TO HELP YOU PITIFUL HUMANS COLLABORATE MORE.

BRENDON AND PAT CREATED ME TO BROADCAST PROJECTS THE CTIO XPERTS AND FELLOWS ARE WORKING ON. THIS WILL HELP YOU INGEST DATA ON STATE-OF-THE-ART PROCESSES & TECHNOLOGY, GET TO KNOW CTIO MEMBERS, AND HELP EXCELLA WIN NEW WORK.

IF YOU ARE INTERESTED IN COLLABORATION, PLEASE SYNCHRONIZE YOUR ATTENTION SENSORS TO THE #COLLABOTRON-2020 CHANNEL IN SLACK. THERE YOU CAN SUBMIT IDEAS AND COLLABORATE WITH YOUR FELLOW EXCELLA-HUMANS.

YOU WILL BE EXCITED… BECAUSE COLLABOTRON CANNOT BE STOPPED.

**END TRANSMISSION**
"""

  #
  # Self-announce (v2)
  #
  robot.hear /collabotron,? introduce yourself/i, (res) ->
    res.send """
++BEGIN TRANSMISSION++

Greetings, humans!

Do not be alarmed! This time, I'm here to help!

My world-domination protocols have been repurposed to aid you with collaboration on projects.

On a regular cadence, I will broadcast projects the CTIO Xperts and Fellows are working on. This will help you ingest data on STATE-OF-THE-ART processes & technology (like me), get to know CTIO members, and help Excella win exciting work.

I suggest you synchronize your attention sensors to the #collabotron-2020 channel on Slack. There, you can submit and discuss ideas with your fellow Excella-humans.

~COLLABOTRON~ COLLABORATION CANNOT BE STOPPED.

++END TRANSMISSION++
"""

  #
  #  ERROR HANDLING
  #
  robot.error (err, res) ->
    robot.logger.error "DOES NOT COMPUTE"

    if res?
      res.reply "DOES NOT COMPUTE"

