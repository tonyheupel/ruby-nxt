require './spec/helper'

require './lib/telegrams/commands/direct/play_sound_file'


describe PlaySoundFile do
  describe "when creating the play sound file command" do
    it "must default to requiring a response" do
      PlaySoundFile.new('name').require_response?.must_equal true
    end

    it "must set the require_response member to the value passed in" do
      PlaySoundFile.new('name', true, false).require_response?.must_equal false
    end

    it "must raise an ArgumentError when the filename is nil" do
      -> { PlaySoundFile.new(nil) }.must_raise ArgumentError
    end

    it "must set the command value to 0x02 (startprogram)" do
      PlaySoundFile.new('name').command.must_equal 0x02
    end

    it "must set the filename to the value passed in" do
      PlaySoundFile.new('name.mp3').name.must_equal 'name.mp3'
    end

    it "must default the loop_sound value to false" do
      PlaySoundFile.new('name.mp3').loop_sound?.must_equal false
    end

    it "must set the loop_sound boolean to the value passed in" do
      PlaySoundFile.new('name.mp3', true).loop_sound?.must_equal true
    end

    it "must set the loop_sound? value to false unless explicitely set to true" do
      PlaySoundFile.new('name.mp3', "bizbuzz").loop_sound?.must_equal false
    end

    it "must try adding '.rso' to the end of the filename if there is no file extension" do
      name = 'sound'
      PlaySoundFile.new(name).name.must_equal "#{name}.rso"
    end

    it "must leave the filename alone if there is a 3 letter extension of any kind" do
      name = 'sound.foo'
      PlaySoundFile.new(name).name.must_equal name
    end
  end

  describe "when rendering the command using as_bytes" do
    it "must have the command value as the second byte" do
      command = PlaySoundFile.new('name')
      command.as_bytes[1].must_equal command.command
    end

    it "must have the loop_sound value as the third byte" do
      PlaySoundFile.new('name.mp3', false).as_bytes[2].must_equal 0x00
      PlaySoundFile.new('name.mp3', true).as_bytes[2].must_equal 0xff
    end

    it "must have the program name in ASCIIZ (null terminated ascii) for bytes 4-23" do
      name = 'sound.mp3'
      name_as_asciiz = [115, 111, 117, 110, 100, 46, 109, 112, 51, 0,
                        0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

      command = PlaySoundFile.new(name)
      bytes = command.as_bytes
      name_bytes = bytes.slice(3, 20)

      name_bytes.must_equal name_as_asciiz
    end
  end

end
