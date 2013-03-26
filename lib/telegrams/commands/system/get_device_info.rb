require_relative '../system_command'

class GetDeviceInfo < SystemCommand
  def initialize
    super
    @command = 0x9B
  end
end
