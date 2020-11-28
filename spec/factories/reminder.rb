FactoryBot.define do
  factory :reminder do
    due_date { Time.now }
    title { 'Call Joseph Ambrose' }
    details { 'Give Joe a call' }
  end
end
