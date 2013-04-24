require_relative '../message_translator'

# OutputModeFlags can be used together with the mode_flags on SetOutputState
class OutputModeFlags
  class << self
    # turn on the specified motor
    def MOTORON
      0x01
    end

    # use run/brake instead of run/float in PWM
    def BRAKE
      0x02
    end

    # turns on the regulation
    def REGULATED
      0x04
    end
  end
end

# Regulation mode is an enumeration used to set how things work when
# in a REGULATED output mode
class RegulationMode
  class << self
    # no regulation will be enabled
    def IDLE
      0x00
    end

    # power control will be enabled on the specified output
    def MOTOR_SPEED
      0x01
    end

    # synchronization will be enabled
    # (needs to be enabled on two outputs)
    def MOTOR_SYNC
      0x02
    end
  end
end

# Run state defines how the motor behaves from where it is
# and how it gets to the new state you have given it
class RunState
  class << self
    # output will be idle
    def IDLE
      0x00
    end

    # output will ramp-up
    def RAMPUP
      0x10
    end

    # output will be running
    def RUNNING
      0x20
    end

    # output will ramp-down
    def RAMPDOWN
      0x40
    end
  end
end

# Output state
class OutputState
  include MessageTranslator

  attr_reader :port, :power, :mode_flags, :regulation_mode,
              :turn_ratio, :run_state, :tacho_limit

  PORTS = {
    :a   => 0x00,
    :b   => 0x01,
    :c   => 0x02,
    :all => 0xff
  }

  REGULATION_MODES = {
    :idle        => RegulationMode.IDLE,
    :motor_speed => RegulationMode.MOTOR_SPEED,
    :motor_sync  => RegulationMode.MOTOR_SYNC
  }

  RUN_STATES = {
    :idle       => RunState.IDLE,
    :ramp_up    => RunState.RAMPUP,
    :running    => RunState.RUNNING,
    :ramp_down  => RunState.RAMPDOWN
  }

  class << self
    def ports
      PORTS.keys
    end

    def regulation_modes
      REGULATION_MODES.keys
    end

    def run_states
      RUN_STATES.keys
    end

    # used with the tacho_limit
    def RUN_FOREVER
      0
    end
  end

  def initialize(options={})
    options = {
      :port => :all,
      :power => 0,
      :mode_flags => 0,
      :regulation_mode => :idle,
      :turn_ratio => 0,
      :run_state => :idle,
      :tacho_limit => 0
    }.merge(options)

    options.keys.each do |key|
      self.send("#{key}=", options[key])
    end
  end

  def ports
    self.class.ports
  end

  def port=(port)
    raise ArgumentError, "invalid port" unless ports.include? port

    @port = port
  end

  def for_port(the_port)
    self.port = the_port
    self
  end

  def power=(power)
    raise ArgumentError, "power must be between -100 and 100" unless power.between?(-100, 100)
    @power = power
  end

  def with_power(power)
    self.power = power
    self
  end

  def mode_flags=(mode_flags)
    raise ArgumentError, "mode_flags must be a valid combination of OutputModeFlags flags (using bitwise-OR)" unless mode_flags.between?(0, 7)
    @mode_flags = mode_flags
  end

  def with_mode_flags(mode_flags)
    self.mode_flags = mode_flags
    self
  end

  def regulation_modes
    self.class.regulation_modes
  end

  def regulation_mode=(regulation_mode)
    raise ArgumentError, "regulation_mode must be a valid regulation mode key" unless regulation_modes.include? regulation_mode
    @regulation_mode = regulation_mode
  end

  def with_regulation_mode(regulation_mode)
    self.regulation_mode = regulation_mode
    self
  end

  def turn_ratio=(turn_ratio)
    raise ArgumentError, "turn_ratio must be between -100 and 100" unless turn_ratio.between?(-100, 100)
    @turn_ratio = turn_ratio
  end

  def with_turn_ratio(turn_ratio)
    self.turn_ratio = turn_ratio
    self
  end

  def run_states
    self.class.run_states
  end

  def run_state=(run_state)
    raise ArgumentError, "run_state must be :idle, :running, :ramp_up, or :ramp_down" unless run_states.include?(run_state)
    @run_state = run_state
  end

  def with_run_state(run_state)
    self.run_state = run_state
    self
  end


  def tacho_limit=(tacho_limit)
    @tacho_limit = tacho_limit
  end

  def with_tacho_limit(tacho_limit)
    self.tacho_limit = tacho_limit
    self
  end

  def as_bytes
    [
      PORTS[port], 
      power,
      mode_flags,
      REGULATION_MODES[regulation_mode],
      turn_ratio,
      RUN_STATES[run_state]
    ].concat(integer_as_ulong_bytes(tacho_limit))
  end


end

