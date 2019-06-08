require 'rails_helper'

def create_restoration
  Restoration.new(
    application_type: 1,
    cemetery: FactoryBot.create(:cemetery),
    submission_date: Date.today,
    amount: '25452.25',
    legal_notice_cost: '123.45'
  )
end

describe Restoration, type: :model do
  subject { create_restoration }

  describe Restoration, 'Associations' do
    it { should have_many :estimates }
    it { should belong_to :cemetery }
    it { should belong_to :reviewer }
  end

  describe Restoration, 'Instance Methods' do
    describe Restoration, 'active?' do
      it 'should return true when restoration is active' do
        expect(subject.active?).to be true
      end

      it 'should return false when the restoration is closed' do
        subject.status = :closed

        expect(subject.active?).to be false
      end
    end

    describe Restoration, 'amount=' do
      it 'should remove the comma from the amount' do
        subject.amount = '12,345.67'

        expect(subject.amount).to eq 12345.67.to_f
      end
    end

    describe Restoration, 'calculated_amount' do
      before :each do
        subject.estimates << Estimate.new(contractor: FactoryBot.create(:contractor), amount: '12345.67', warranty: 20, proper_format: true)
      end

      it 'returns the correct amount' do
        expect(subject.calculated_amount).to eq 12469.12
      end
    end

    describe Restoration, 'current_processing_step' do
      it 'returns 0 when the processing has not started' do
        expect(subject.current_processing_step).to eq 0
      end

      it 'returns 1 if only the application form has been added' do
        subject.application_form.attach(io: File.open(Rails.root.join('lib', 'document_templates', 'rules-approval.docx')), filename: 'Rules.docx', content_type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document')

        expect(subject.current_processing_step).to eq 1
      end

      it 'returns 2 if an estimate has been added' do
        subject.estimates << Estimate.new(contractor: FactoryBot.create(:contractor), amount: '12345.67', warranty: 20, proper_format: true)

        expect(subject.current_processing_step).to eq 2
      end

      it 'returns 3 if a legal notice has been added' do
        subject.legal_notice.attach(io: File.open(Rails.root.join('lib', 'document_templates', 'rules-approval.docx')), filename: 'Rules.docx', content_type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document')

        expect(subject.current_processing_step).to eq 3
      end

      it 'returns 4 if the question about a previous application has been answered' do
        subject.previous_exists = true

        expect(subject.current_processing_step).to eq 4
      end

      it 'returns 0 if the application is no longer in processing' do
        subject.status = :processed
        subject.previous_exists = true

        expect(subject.current_processing_step).to eq 0
      end
    end

    describe Restoration, '#formatted_application_type' do
      it 'returns the correct application type' do
        expect(subject.formatted_application_type).to eq 'Vandalism'
      end
    end

    describe Restoration, '#formatted_previous_type' do
      it 'returns the correct previous application type' do
        subject.previous_type = 1

        expect(subject.formatted_previous_type).to eq 'Vandalism'
      end
    end

    describe Restoration, '#named_status' do
      it 'returns the correct named status' do
        subject.status = :paid

        expect(subject.named_status).to eq 'Awaiting repairs'
      end
    end

    describe Restoration, '#newly_created?' do
      it 'returns true if the restoration is new' do
        expect(subject.newly_created?).to be true
      end

      it 'returns false when the restoration is not new' do
        subject.save

        expect(subject.newly_created?).to be false
      end
    end

    describe Restoration, 'to_s' do
      it 'returns the identifier' do
        subject.save

        expect(subject.to_s).to eq "VAND-#{Date.today.year}-0001"
      end
    end
  end
end
