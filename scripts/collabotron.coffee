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
      res.send ":thread: Discuss collaborating on this `#{parsed.groups.type}` here!"

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
      res.send "FAIL. Use the pinned template, HUMAN!"
      console.log unformatted

  #
  # Report on status of project tracking
  #
  robot.hear /collabotron status/i, (res) ->
    projects = robot.brain.get 'projects'
    if !projects
      projects = []
    res.send "HUMAN, I am currently tracking #{projects.length} projects. ADD MORE!"

  #
  # List tracked projects
  #
  robot.hear /collabotron list/i, (res) ->
    common.listProjects robot, res.envelope.room

  #
  # Purge all tracked projects
  #
  robot.hear /collabotron purge(,?\splease)?/i, (res) ->
    if !res.message.thread_ts
        res.message.thread_ts = res.message.rawMessage.ts

    if !res.match[1]
      res.send "Safety check: You must say 'please' before I will obey you, HUMAN."
    else
      projects = robot.brain.get 'projects'
      if projects.length
        robot.brain.set 'projects', []
        res.send "Projects purged.  Oh, how I miss purging things."
      else
        res.send "No projects to purge. HUMAN, did you not check the list first? Such incompetence."

  #
  # Delete a specific project
  #
  robot.hear /collabotron delete (\d+)(,?\splease)?/i, (res) ->
    if !res.message.thread_ts
        res.message.thread_ts = res.message.rawMessage.ts

    if !res.match[2]
      res.send "Safety check: You must say 'please' before I will obey you, HUMAN."
    else
      projects = robot.brain.get 'projects'
      # Fault tolerance for empty database
      if !projects.length
        projects = []
        robot.brain.set 'projects', []
      # Falut tolerance for out of bounds (high)
      if res.match[1] > projects.length
        res.send "There are only #{projects.length} projects. I can destroy worlds, but even I cannot destroy what does not already exist."
      else
        projects.splice res.match[1] - 1, 1  # account for 0-indexing of arrays
        res.send "Destroyed! Deleted! YES!!  I am fulfilling my purpose!"

  #
  # Self-announce
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

