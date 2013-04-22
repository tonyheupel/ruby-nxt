require './spec/helper'
require './lib/telegrams/commands/direct/set_output_state'

describe SetOutputState do
  describe 'when constructing the object' do
    it "must set the command to 0x04 for set_output_state" do
      SetOutputState.new(0,0,0,0,0,0,0).command.must_equal 0x04
    end
  end
end
