FactoryBot.define do
  factory :estimate do
    association :contractor, factory: :contractor
    amount { '12345.67' }
    warranty { 20 }
    proper_format { true }

    factory :higher_estimate do
      amount { '23456.78' }
    end
  end
end
