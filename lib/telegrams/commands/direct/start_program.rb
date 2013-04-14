require_relative '../direct_command'
require_relative '../message_translator'

class StartProgram < DirectCommand
  include MessageTranslator

  attr_reader :name

  def initialize(program_name, require_response=true)
    raise ArgumentError, "program_name is required" if program_name.nil?

    super(require_response)
    @command = 0x00  # startprogram
    @name = adjust_program_name(program_name)
  end

  def as_bytes
   bytes = super
   bytes.concat program_name_as_bytes
  end

  private
  def program_name_as_bytes
    string_as_bytes(@name)
  end

  def adjust_program_name(name)
    add_default_extension_if_missing(name, 'rxe')
  end
end
