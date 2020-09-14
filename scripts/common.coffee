  # Description/Abstract: (500 character limit)A paragraph description of the project
  # Project Type: (talk, whitepaper, code, etc.)
  # Purpose/Value: (How will it benefit Excella)
  # What's in it for me? (Why people should collaborate)
  #
  newline = "(\n|\r|\n\r|\r\n)"
  template = ///
    # Description
    ((Description\/Abstract:)|(Description:)|(Abstract:))\s?(?<description>[^\n\r]+)#{newline}
    # Project Type
    (Project\sType:)\s?(?<type>[^\n\r]+)#{newline}
    # Value header
    ((Purpose\/Value:)|(Purpose:)|(Value:))\s?(?<value>[^\n\r]+)#{newline}
    # Benefits
    (What's\sin\sit\sfor\sme\?)\s?(?<benefit>[^\n\r]+)#{newline}?
    ///

  templateIndicator = /((Description\/Abstract)|(Description)|(Abstract))((.|\s)*)/i

  exports.template = template
  exports.templateIndicator = templateIndicator
