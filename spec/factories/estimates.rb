FactoryBot.define do
  factory :estimate do
    document { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'test.pdf')) }
    association :contractor, factory: :contractor
    amount { '12345.67' }
    warranty { 20 }
    proper_format { true }

    factory :higher_estimate do
      amount { '23456.78' }
    end

    factory :highest_estimate do
      amount { '34567.89' }
    end
  end
end
