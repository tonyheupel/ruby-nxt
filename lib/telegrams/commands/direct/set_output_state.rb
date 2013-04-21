require_relative '../direct_command'

class SetOutputState < DirectCommand
  def initialize(output_port, power, mode_flags, regulation_mode, turn_ratio, run_state, tacho_limit, wait_for_reply=true)
    super(wait_for_reply)
    @command = 0x04
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
