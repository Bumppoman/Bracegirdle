require 'rails_helper'

def create_vandalism
  Vandalism.new(
    amount: '25452.25'
  )
end

describe Vandalism, type: :model do
  describe Vandalism, 'Associations' do
    it { should have_many :estimates }
  end
end
