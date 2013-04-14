require_relative '../../direct_command_reply'

class StartProgramReply < DirectCommandReply
  def initialize(bytes)
    super(bytes)
  end

  # override
  def validate_bytes(bytes)
    super(bytes)
    raise ArgumentError, "must be a reply for a StartProgram command" unless bytes[1] == 0x00
  end
end
