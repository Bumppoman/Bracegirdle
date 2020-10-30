FactoryBot.define do
  factory :appointment do
    user_id { 1 }
    cemetery_cemid { "04001" }
    add_attribute(:begin) { Time.strptime('10:00', '%H:%M') }
    add_attribute(:end) { Time.strptime('11:00', '%H:%M') }
    status { :scheduled }
  end
end
