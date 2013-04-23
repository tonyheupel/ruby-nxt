require_relative '../direct_command'
require_relative './output_state'

class SetOutputState < DirectCommand
  attr_reader :output_state

  def initialize(output_state, wait_for_reply=true)
    super(wait_for_reply)
    @command = 0x04

    raise ArgumentError, "output_state must be a valid OutputState object" if output_state.nil?
    @output_state = output_state
  end

  def as_bytes
    super.concat(@output_state.as_bytes)
  end

end

