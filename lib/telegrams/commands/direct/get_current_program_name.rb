require_relative '../direct_command'

class GetCurrentProgramName < DirectCommand
  def initialize  # cannot override require_response? since it's asking for one
    super
    @command = 0x11
  end
end
