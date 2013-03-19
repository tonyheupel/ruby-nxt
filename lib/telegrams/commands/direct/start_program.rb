require_relative '../direct_command'

class StartProgram < DirectCommand
  attr_reader :name

  PROGRAM_NAME_MAX_LENGTH = 20 # 15.3 + null terminator
  def initialize(program_name, require_response=true)
    raise ArgumentError, "program_name is required" if program_name.nil?

    super(require_response)
    @command = 0x00  # startprogram
    @name = program_name
  end

  def as_bytes
   bytes = super
   bytes.concat program_name_as_bytes
  end

  private
  def program_name_as_bytes
    # pad out to max program name length with null characters
    # and then convert all to ASCIIZ
    @name.ljust(PROGRAM_NAME_MAX_LENGTH, "\0").unpack('C*')
  end
end
