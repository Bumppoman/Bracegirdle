FactoryBot.define do
  factory :attachment do
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'test.pdf')) }
    description { 'Testing attachment' }
  end
end
