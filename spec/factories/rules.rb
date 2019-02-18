FactoryBot.define do
  factory :rules do
    cemetery_id { 1 }
    sender { 'Herman Munster' }
    request_by_email { true }
    sender_email { 'herman@munster.com' }
    rules_documents { fixture_file_upload(Rails.root.join('lib', 'document_templates', 'rules-approval.docx')) }

    factory :revision_requested do
      status { 3 }
      revision_request_date { Date.current + 7}
      investigator_id { 1 }

      factory :revision_requested_last_week do
        revision_request_date { Date.current - 7 }
      end
    end

    factory :another_investigator_rules do
      investigator_id { 2 }
      status { 2 }
    end
  end
end