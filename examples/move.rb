require_relative '../lib/nxt'

nxt = NXT.new('/dev/tty.NXT-DevB')

puts "Connecting..."
nxt.connect

puts "Driving forward two rotations, ramping up to 75 power and then coasting..."
state = OutputState.new :port => :c,
                        :power => 75,
                        :mode_flags => OutputModeFlags.REGULATED | OutputModeFlags.MOTORON,
                        :regulation_mode => :motor_sync,
                        :run_state => :running,
                        :tacho_limit => 360 * 2

nxt.set_output_state state
puts "Doesn't go yet..."
sleep(2)

state = OutputState.new :port => :b,
                        :power => 75,
                        :mode_flags => OutputModeFlags.REGULATED | OutputModeFlags.MOTORON,
                        :regulation_mode => :motor_sync,
                        :run_state => :running,
                        :tacho_limit => 360 * 2

puts "Should go now..."
nxt.set_output_state state
sleep(3)

state = OutputState.new :port => :all,
                        :power => 0,
                        :mode_flags => OutputModeFlags.BRAKE,
                        :regulation_mode => :idle,
                        :run_state => :idle,
                        :tacho_limit => 0 # unlimited

nxt.set_output_state state
sleep(1)
nxt.reset_motor_position

puts "Done moving."
nxt.disconnect
