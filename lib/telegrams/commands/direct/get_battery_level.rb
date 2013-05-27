require_relative '../direct_command'

class GetBatteryLevel < DirectCommand
  def initialize
    super(true)
    @command = 0x0B
  end
end
