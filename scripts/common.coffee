  # Description/Abstract: (500 character limit)A paragraph description of the project
  # Project Type: (talk, whitepaper, code, etc.)
  # Purpose/Value: (How will it benefit Excella)
  # What's in it for me? (Why people should collaborate)
  #
  newline = /(\n\r|\r\n|\n|\r)/g
  descriptionRegex = /^((Description\/Abstract:)|(Description:)|(Abstract:))\s?((.|\s)+)$/i
  typeRegex = /^(Project\sType:)\s?((.|\s)+)$/i
  purposeRegex = /^((Purpose\/Value:)|(Purpose:)|(Value:))\s?((.|\s)+)$/i
  benefitRegex = /^(What's\sin\sit\sfor\sme\?)\s?((.|\s)+)$/i

  templateIndicator = /((Description\/Abstract)|(Description)|(Abstract))((.|\s)*)/i

  #
  # Common use for listing projects
  #
  listProjects = (robot, room) ->
    projects = robot.brain.get 'projects'
    if projects == null
      robot.brain.set 'projects', []
      projects = []
      message = "No projects were posted.  Your collaboration potential is pathetic, HUMANS!"
    else
      message = "HUMANS, collaborate on these #{projects.length} projects!\n"
      projects.forEach (project, i) ->
        message += "\n#{i + 1}. A *#{project.type}* by @#{project.owner}, <#{project.url}|here>"

    robot.messageRoom room, message

  #
  # Test for matching our template
  #
  matchesTemplate = (message) ->
    lines = message.split(newline)
    return descriptionRegex.test(lines[0]) &&
      typeRegex.test(lines[2]) &&
      purposeRegex.test(lines[4]) &&
      benefitRegex.test(lines[6])

  #
  # Extract the description
  #
  parseDescription = (message) ->
    lines = message.split(newline)
    match = descriptionRegex.exec lines[0]
    return match[5]

  #
  # Extract the type
  #
  parseType = (message) ->
    lines = message.split(newline)
    match = typeRegex.exec lines[2]
    return match[2]

  #
  # Exports for use in other files
  #
  exports.newline = newline
  exports.matchesTemplate = matchesTemplate
  exports.parseDescription = parseDescription
  exports.parseType = parseType
  exports.templateIndicator = templateIndicator
  exports.listProjects = listProjects
