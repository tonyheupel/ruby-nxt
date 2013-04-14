require_relative '../../direct_command_reply'

class StopProgramReply < DirectCommandReply
  def initialize(bytes)
    super(bytes)
  end

  # override
  def validate_bytes(bytes)
    super(bytes)
    raise ArgumentError, "must be a reply for a StopProgram command" unless bytes[1] == 0x01
  end
end
