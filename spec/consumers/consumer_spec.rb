require 'rails_helper'

describe Consumer do
  describe 'Not implemented' do
    it 'raises a NotImplementedError' do
      expect { Consumer.new({}).call }.to raise_error(NotImplementedError)
    end
  end
end