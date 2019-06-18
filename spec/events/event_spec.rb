require 'rails_helper'

describe Event do
  describe 'Not implemented' do
    it 'raises a NotImplementedError' do
      expect { Event.new.event_type }.to raise_error(NotImplementedError)
    end
  end
end