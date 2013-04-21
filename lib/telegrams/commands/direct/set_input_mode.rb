require_relative '../direct_command'

class SetInputMode < DirectCommand

  class << self
    def input_ports; INPUT_PORTS.keys; end
    def sensor_types; SENSOR_TYPES.keys; end
    def sensor_modes; SENSOR_MODES.keys; end
  end

  attr_reader :input_port, :sensor_type, :sensor_mode

	def initialize(input_port, sensor_type, sensor_mode, response_required=true)
		super(response_required)
		@command = 0x05

    validate_arguments(input_port, sensor_type, sensor_mode)
    @input_port = input_port
    @sensor_type = sensor_type
    @sensor_mode = sensor_mode
	end

  INPUT_PORTS = {
    one: 0x00,
    two: 0x01,
    three: 0x02,
    four: 0x03
  }

  SENSOR_TYPES = {}
  [:no_sensor,
   :switch,
   :temperature,
   :reflection,
   :angle,
   :light_active,
   :light_inactive,
   :sound_db,
   :sound_dba,
   :custom,
   :lowspeed,
   :lowspeed_9v,
   :highspeed,
   :colorfull,
   :colorred,
   :colorgreen,
   :colorblue,
   :colornone
  ].each_with_index do |key, index|
    SENSOR_TYPES[key] = index
  end

  SENSOR_MODES = {
    :rawmode => 0x00,
    :booleanmode => 0x20,
    :transitioncntmode => 0x40,
    :periodcountermode => 0x60,
    :pctfullscalemode => 0x80,
    :celsiusmode => 0xA0,
    :fahrenheitmode => 0xC0,
    :anglestepmode => 0xE0,
    :slopemask => 0x1F,
    :modemask => 0xE0
  }

  def sensor_types
    self.class.sensor_types
  end

  def sensor_modes
    self.class.sensor_modes
  end

  def input_ports
    self.class.input_ports
  end

  def as_bytes
    super << INPUT_PORTS[@input_port] << SENSOR_TYPES[@sensor_type] << SENSOR_MODES[@sensor_mode]
  end

  private
  def validate_arguments(input_port, sensor_type, sensor_mode)
    validate_input_port(input_port)
    validate_sensor_type(sensor_type)
    validate_sensor_mode(sensor_mode)
  end

  def validate_input_port(input_port)
    raise ArgumentError, "Invalid input port" unless input_ports.include? input_port
  end

  def validate_sensor_type(sensor_type)
    raise ArgumentError, "Invalid sensor type" unless sensor_types.include? sensor_type
  end

  def validate_sensor_mode(sensor_mode)
    raise ArgumentError, "Invalid sensor mode" unless sensor_modes.include? sensor_mode
  end

end
