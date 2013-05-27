# NXT
A ruby gem for controlling Lego Mindstorms NXT 2.0

## Installation
Either install it from the command-line:

```shell
$ gem install nxt
```

or add to your Gemfile and install it:
```ruby
source "https://rubygems.org"

gem 'nxt'
```
```shell
$ bundle install
```

## Usage
The most basic usage can be done using the NXT class by connecting your NXT 2.0
brick over Bluetooth.  In the examples below, the brick is connected at
```/dev/tty.NXT-/devB```:

```ruby
require 'nxt'

nxt = Nxt.new('/dev/tty.NXT-/devB')

puts "Connecting..."
nxt.connect

puts "Moving what is typically the right wheel one rotation..."
state = OutputState.new :port => :c,
                        :power => 55,
                        :mode_flags => OutputModeFlags.MOTORON | OutputModeFlags.BRAKE,
                        :regulation_mode => :motor_speed,
                        :run_state => :running,
                        :tacho_limit => 360  # degrees = 1 rotation

nxt.set_output_state state
```

