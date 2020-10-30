FactoryBot.define do
  factory :rules_approval do
    cemetery_cemid { '04001' }
    trustee_id { 1 }
    request_by_email { true }
    sender_email { 'herman@munster.com' }
    submission_date { Date.current - 2 }
    
    after(:create) do |rules_approval|
      rules_approval.revisions << FactoryBot.create(:revision)
      rules_approval.revisions.first.rules_document.attach fixture_file_upload(Rails.root.join('spec', 'support', 'test.pdf'))
    end

    factory :revision_requested do
      status { :revision_requested }
      investigator_id { 1 }
      
      after(:create) do |rules_approval|
        rules_approval.revisions << FactoryBot.create(:revision, status: :requested)
      end
    end

    factory :another_investigator_rules_approval do
      investigator_id { 2 }
      status { :pending_review }
    end

    factory :approved_rules_approval do
      investigator_id { 1 }
      status { :approved }
      approval_date { Date.current }

      factory :approved_rules_approval_mailed do
        request_by_email { false }
        sender_street_address { '123 Main St.' }
        sender_city { 'Deposit' }
        sender_state { 'NY' }
        sender_zip { '13345' }
      end
      
      after(:create) do |rules_approval|
        FactoryBot.create(:rules)
      end
    end
  end
end