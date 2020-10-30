require 'rails_helper'

describe NotificationMailer, type: :mailer do
  before :each do
    @employee = FactoryBot.create(:user)
    @supervisor = FactoryBot.create(:mean_supervisor)
    @cemetery = FactoryBot.create(:cemetery)
    @complaint = FactoryBot.create(:brand_new_complaint, receiver_id: 2)
    @comment = @complaint.notes.new(user_id: 1, body: 'Testing.')
    @notification = FactoryBot.create(:notification, object: @comment, message: 'comment')
  end

  it 'sends the properly formatted email' do
    expect {
      NotificationMailer.note_comment_email(@employee.id, @notification.id).deliver_now
    }.to change { ActionMailer::Base.deliveries.count }.by(1)

    mail = ActionMailer::Base.deliveries.last

    expect(mail.subject).to eq "John Smith added a comment to complaint #CPLT-#{@complaint.created_at.year}-00001 against Anthony Cemetery"
  end
end
