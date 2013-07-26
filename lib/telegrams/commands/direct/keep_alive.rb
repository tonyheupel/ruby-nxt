require_relative '../direct_command'
class KeepAlive < DirectCommand
  def initialize
    super(true)
    @command = 0x0D
  end
end
