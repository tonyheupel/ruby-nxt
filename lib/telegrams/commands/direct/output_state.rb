
# Output state
class OutputState
  attr_reader :port, :power, :mode_flags, :regulation_mode,
              :turn_ratio, :run_state, :tacho_limit

  PORTS = {
    :a   => 0x00,
    :b   => 0x01,
    :c   => 0x02,
    :all => 0xff
  }

  class << self
    def ports
      PORTS.keys
    end
  end

  def initialize(options={})
    options = {
      :port => :all,
      :power => 0,
      :mode_flags => 0,
      :regulation_mode => 0,
      :turn_ratio => 0,
      :run_state => 0,
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
    raise ArgumentError unless ports.include? port

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

  def regulation_mode=(regulation_mode)
  end

  def with_regulation_mode(regulation_mode)
  end

  def turn_ratio=(turn_ratio)
  end

  def with_turn_ratio(turn_ratio)
  end

  def run_state=(run_state)
  end

  def with_run_state(run_state)
  end

  def tacho_limit=(tacho_limit)
  end

  def with_tacho_limit(tacho_limit)
  end


end

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
