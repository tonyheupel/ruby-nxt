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
    bt.disconnect
  end
  puts "Done."
end
