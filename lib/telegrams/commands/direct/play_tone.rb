require_relative '../direct_command'
require_relative '../message_translator'

class PlayTone < DirectCommand
  include MessageTranslator

  attr_reader :frequency, :duration

  def initialize(frequency_hz, duration_ms, require_response=true)
    super(require_response)
    @command = 0x03
    validate_arguments(frequency_hz, duration_ms)
    @frequency = frequency_hz
    @duration = duration_ms
  end

  def as_bytes
    super.concat(integer_as_uword_bytes(@frequency)).concat(integer_as_uword_bytes(@duration))
  end

  private
  def validate_arguments(frequency_hz, duration_ms)
    validate_frequency(frequency_hz)
    validate_duration(duration_ms)
  end

  def validate_frequency(frequency_hz)
    raise ArgumentError, "The frequency must be between 200 and 14000 Hz" unless frequency_hz.between?(200, 14000)
  end

  def validate_duration(duration_ms)
    raise ArgumentError, "The duration in milliseconds must be a positive number or zero" unless duration_ms >= 0
  end
end
