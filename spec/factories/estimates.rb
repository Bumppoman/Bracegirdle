FactoryBot.define do
  factory :estimate do
    contractor { FactoryBot.create(:contractor) }
    amount { '12345.67' }
    warranty { 20 }
    proper_format { true }
  end
end
