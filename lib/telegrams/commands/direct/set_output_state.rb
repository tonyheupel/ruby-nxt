require_relative '../direct_command'

class SetOutputState < DirectCommand
  def initialize(output_port, power, mode_flags, regulation_mode, turn_ratio, run_state, tacho_limit, wait_for_reply=true)
    super(wait_for_reply)
    @command = 0x04
  end
end

