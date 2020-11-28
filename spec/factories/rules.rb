FactoryBot.define do
  factory :rules do
    cemetery_cemid { '04001' }
    rules_approval_id { 1 }
    approval_date { Date.current }
    rules_document { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'test.pdf')) }
  end
end
