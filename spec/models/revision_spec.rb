require 'rails_helper'

def create_revision
  Revision.new(
    rules_approval_id: 1
  )
end

RSpec.describe Revision, type: :model do
  subject { create_revision }
  
  describe 'Instance Methods' do
    describe Revision, '#date_requested' do
      it 'provides the correct date' do
        subject.status = :requested
        FactoryBot.create(:cemetery)
        FactoryBot.create(:trustee)
        FactoryBot.create(:rules_approval)
        subject.save
        subject.status_changes.create(status: Revision.statuses['requested'])
        
        expect(subject.date_requested).to eq Date.current.strftime('%B %-e, %Y')
      end
    end
    
    describe Revision, '#formatted_date_received' do
      it 'provides the correct text when status is requested' do
        expect(subject.formatted_date_received).to eq 'Not yet received'
      end
      
      it 'provides the correct text when status is withdrawn' do
        subject.status = :withdrawn
        expect(subject.formatted_date_received).to eq 'Rules approval withdrawn'
      end
      
      it 'provides the correct date when status is received' do
        subject.status = :received
        FactoryBot.create(:cemetery)
        FactoryBot.create(:trustee)
        FactoryBot.create(:rules_approval)
        subject.save
        subject.status_changes.create(status: Revision.statuses['received'])
        
        expect(subject.formatted_date_received).to eq Date.current.strftime('%B %-e, %Y')
      end
    end
  end
end
