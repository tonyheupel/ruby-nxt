require './spec/helper'

require './lib/telegrams/commands/direct/start_program'


describe StartProgram do
  describe "when creating the start program command" do
    it "must default to requiring a response" do
      StartProgram.new('name').require_response?.must_equal true
    end

    it "must set the require_response member to the value passed in" do
      StartProgram.new('name', false).require_response?.must_equal false
    end

    it "must raise an ArgumentError when the program name is nil" do
      -> { StartProgram.new(nil) }.must_raise ArgumentError
    end

    it "must set the command value to 0x00 (startprogram)" do
      StartProgram.new('name').command.must_equal 0x00
    end

    it "must set the program name to the value passed in" do
      StartProgram.new('name.rxe').name.must_equal 'name.rxe'
    end

    it "must try adding '.rxe' to the end of the filename if there is no file extension" do
      name = 'program'
      StartProgram.new(name).name.must_equal "#{name}.rxe"
    end

    it "must leave the filename alone if there is a 3 letter extension of any kind" do
      name = 'program.foo'
      StartProgram.new(name).name.must_equal name
    end
  end

  describe "when rendering the command using as_bytes" do
    it "must have the command value as the second byte" do
      command = StartProgram.new('name')
      command.as_bytes[1].must_equal command.command
    end

    it "must have the program name in ASCIIZ (null terminated ascii) for bytes 3-22" do
      name = 'myrobot.rxe'
      name_as_asciiz = [109, 121, 114, 111, 98, 111, 116, 46, 114, 120, 101, 0,
                        0, 0, 0, 0, 0, 0, 0, 0]

      command = StartProgram.new(name)
      bytes = command.as_bytes
      name_bytes = bytes.slice(2, 20)

      name_bytes.must_equal name_as_asciiz
    end
  end

end
