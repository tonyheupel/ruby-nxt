require_relative '../direct_command'
require_relative '../message_translator'

class PlaySoundFile < DirectCommand
  include MessageTranslator

  attr_reader :name

  def initialize(sound_filename, loop_sound=false, require_response=true)
    raise ArgumentError, "sound_filename is required" if sound_filename.nil?

    super(require_response)
    @command = 0x02  # playsoundfile
    @name = adjust_sound_filename(sound_filename)
    @loop_sound = loop_sound
  end

  def loop_sound?
    @loop_sound == true
  end

  def as_bytes
   bytes = super.concat(loop_sound_as_bytes).concat(filename_as_bytes)
  end

  private
  def loop_sound_as_bytes
    boolean_as_bytes(loop_sound?)
  end

  def filename_as_bytes
    string_as_bytes(@name)
  end

  def adjust_sound_filename(name)
    add_default_extension_if_missing(name, 'rso')
  end
end
