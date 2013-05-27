require_relative '../direct_command'

class ResetMotorPosition < DirectCommand
  def initialize(require_response=true)
    super
    @command = 0x0A
  end
end
