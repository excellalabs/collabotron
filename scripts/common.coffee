  # Description/Abstract: (500 character limit)A paragraph description of the project
  # Project Type: (talk, whitepaper, code, etc.)
  # Purpose/Value: (How will it benefit Excella)
  # What's in it for me? (Why people should collaborate)
  #
  newline = "(\n|\r|\n\r|\r\n)"
  template = /((Description\/Abstract:)|(Description:)|(Abstract:))\s?(?<description>[^\n\r]+)(\n|\r|\n\r|\r\n)(Project\sType:)\s?(?<type>[^\n\r]+)(\n|\r|\n\r|\r\n)((Purpose\/Value:)|(Purpose:)|(Value:))\s?(?<value>[^\n\r]+)(\n|\r|\n\r|\r\n)(What's\sin\sit\sfor\sme\?)\s?(?<benefit>[^\n\r]+)(\n|\r|\n\r|\r\n)?/i

  templateIndicator = /((Description\/Abstract)|(Description)|(Abstract))((.|\s)*)/i

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

  exports.template = template
  exports.templateIndicator = templateIndicator
  exports.listProjects = listProjects
