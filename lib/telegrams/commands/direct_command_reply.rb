require_relative '../reply'
require_relative './direct_command'

class DirectCommandReply < Reply
  attr_reader :command, :status

  def initialize(bytes)
    super()
    raise ArgumentError, "must be a reply message" unless bytes[0] == @type
    raise ArgumentError, "must have at least 3 bytes ([type, command, status])" unless bytes.size >= 3

    @command = bytes[1]
    @status = bytes[2]
  end

end

