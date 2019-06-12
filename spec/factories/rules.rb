FactoryBot.define do
  factory :rules do
    cemetery_id { 1 }
    sender { 'Herman Munster' }
    request_by_email { true }
    sender_email { 'herman@munster.com' }
    submission_date { Date.current - 2 }

    factory :revision_requested do
      status { :revision_requested }
      revision_request_date { Date.current + 7}
      investigator_id { 1 }

      factory :revision_requested_last_week do
        revision_request_date { Date.current - 7 }
      end
    end

    factory :another_investigator_rules do
      investigator_id { 2 }
      status { :pending_review }
    end

    factory :approved_rules do
      investigator_id { 1 }
      status { :approved }
      approval_date { Date.current }
      rules_documents { [fixture_file_upload(Rails.root.join('spec', 'support', 'test.pdf'), 'application/pdf')] }
    end
  end
end