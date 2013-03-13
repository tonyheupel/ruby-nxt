require_relative '../direct_command'

class StopProgram < DirectCommand
  def initialize(require_response=true)
    super
    @command = 0x01
  end

end
