require_relative '../direct_command'
require_relative './output_state'
require 'forwardable'

class SetOutputState < DirectCommand
  extend Forwardable

  def initialize(output_state, wait_for_reply=true)
    super(wait_for_reply)
    @command = 0x04

    raise ArgumentError, "output_state must be a valid OutputState object" if output_state.nil?
    @output_state = output_state
  end

  def as_bytes
    super.concat(@output_state.as_bytes)
  end

  # follow Law of Demeter and hide internal access to output_state
  def_delegators :@output_state, :port, :power, :mode_flags, :regulation_mode,
                                 :turn_ratio, :run_state, :tacho_limit

  private
  def output_state
    @output_state
  end
end

