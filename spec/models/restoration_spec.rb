require 'rails_helper'

def create_restoration
  Restoration.new(
    amount: '25452.25'
  )
end

describe Restoration, type: :model do
  describe Restoration, 'Associations' do
    it { should have_many :estimates }
  end
end
