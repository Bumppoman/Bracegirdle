FactoryBot.define do
  factory :revision do
    rules_approval_id { 1 }
    comments { 'Initial revision' }
    submission_date { Date.current }
    status { 3 }
    
    after(:create) do |revision|
      revision.status_changes << StatusChange.new(status: 3, created_at: Time.now, initial: true, final: true)
    end
  end
end
