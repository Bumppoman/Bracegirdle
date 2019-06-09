require 'rails_helper'

def create_estimate
  Estimate.new(
    amount: '12345.67',
    warranty: 20
  )
end

describe Estimate, type: :model do
  subject { create_estimate }

  context Estimate, 'Associations' do
    it { should belong_to :contractor }
    it { should belong_to :restoration }
  end

  context Estimate, 'Instance Methods' do
    describe Estimate, '#amount=' do
      it 'removes the comma when adding an estimate' do
        subject.amount = '23,456.78'

        expect(subject.amount).to eq 23456.78
      end

      it 'accepts a number without a comma' do
        subject.amount = '23456.78'

        expect(subject.amount).to eq 23456.78
      end
    end

    describe Estimate, '#formatted_warranty' do
      it 'returns the correct warranty length' do
        expect(subject.formatted_warranty).to eq '20 years'
      end

      it 'returns lifetime when appropriate' do
        subject.warranty = 1000

        expect(subject.formatted_warranty).to eq 'Lifetime'
      end
    end
  end
end