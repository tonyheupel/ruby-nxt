Dir.chdir(File.join(File.dirname(__FILE__), "../"))

require './lib/nxt'

path = '/dev/tty.NXT-DevB'
nxt = NXT.new(path)

puts "Connecting to #{path}..."
nxt.connect

puts "Getting device information..."
info = nxt.get_device_info

puts "\nDEVICE INFORMATION"
puts "Name: \t\t\t\t#{info.nxt_brick_name}"
puts "Bluetooth Address: \t\t#{info.bt_address}"
puts "Signal Strength: \t\t#{info.signal_strength}"
puts "Free user memory (bytes): \t#{info.free_user_flash_memory_bytes}"

puts "\nDisconnecting..."
nxt.disconnect
puts "Done."
