FactoryBot.define do
  factory :attachment do
    file { fixture_file_upload Rails.root.join('spec', 'support', 'test.pdf'), 'application/pdf' }
    description { 'Testing attachment' }
  end
end
