require_relative '../direct_command'

class StopSoundPlayback < DirectCommand
  def initialize(require_response=true)
    super(require_response)
    @command= 0x0C
  end
end
