FactoryBot.define do
  factory :appointment do
    user_id { 1 }
    cemetery_id { 1 }
    add_attribute(:begin) { Time.now }
    add_attribute(:end) { Time.now + 1.hour }
    status { :scheduled }
  end
end
