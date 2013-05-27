Dir.chdir(File.join(File.dirname(__FILE__), ".."))
require "./lib/communication/bluetooth_communication"

require "./lib/telegrams/commands/direct/start_program"
require "./lib/telegrams/commands/direct/stop_program"
require "./lib/telegrams/no_message_reply"
require "./lib/telegrams/commands/direct/get_current_program_name"
require "./lib/telegrams/commands/direct/replies/get_current_program_name_reply"

device = '/dev/tty.NXT-DevB'
bt = BluetoothCommunication.new(device)

name = 'DemoV2.rxe'
start = StartProgram.new(name)
stop = StopProgram.new
current_program = GetCurrentProgramName.new

puts "Connecting to #{device}..."
bt.connect

puts "Starting program #{name}..."
bt.send_message(start, NoMessageReply) do | reply |
  raise "Problem starting program: #{reply.status}" unless reply.success?

  program_name = bt.send_message(current_program, GetCurrentProgramNameReply).program_name

  puts "#{program_name} is running..."

  puts "Stopping program #{program_name}..."
  bt.send_message(stop, NoMessageReply) do | stop_reply |
    raise "Problem stopping program: #{stop_reply.status}" unless stop_reply.success?

    puts "Stopped."

    puts "Disconnecting."
#    bt.disconnect
  end
  puts "Done."
end

require './lib/telegrams/commands/system/get_device_info'
require './lib/telegrams/commands/system/replies/get_device_info_reply'

puts "Connecting..."
#bt.connect

get_device_info = GetDeviceInfo.new
device_info = bt.send_message(get_device_info, GetDeviceInfoReply)

raise "Error getting device info: #{device_info.status}" unless device_info.success?
#bt.disconnect

puts "Name: #{device_info.nxt_brick_name}"
puts "Bluetooth address: #{device_info.bt_address}"
puts "Signal strength: #{device_info.signal_strength}"
puts "Free user Flash memory #{device_info.free_user_flash_memory_bytes} (#{device_info.free_user_flash_memory_bytes / 1024} KB)"


require './lib/telegrams/commands/direct/get_battery_level'
require './lib/telegrams/commands/direct/replies/get_battery_level_reply'

puts "Connecting..."
# bt.connect

get_battery_level = GetBatteryLevel.new
level = bt.send_message(get_battery_level, GetBatteryLevelReply)

raise "Error getting battery level: #{level.status}" unless level.success?
bt.disconnect

puts "Battery level (millivolts): #{level.millivolts}"
puts "Battery level (volts): #{level.volts}"

