FactoryBot.define do
  factory :rules do
    cemetery_id { 1 }
    sender { 'Herman Munster' }
    request_by_email { true }
    sender_email { 'herman@munster.com' }
    rules_documents { fixture_file_upload(Rails.root.join('lib', 'document_templates', 'rules-approval.docx')) }

    factory :my_region_taken do
      status { 2 }
      accepted_by_id { 2 }
    end

    factory :other_region do
      cemetery_id { 2 }

      factory :other_region_taken do
        status { 2 }
        accepted_by_id { 2 }
      end
    end

    factory :revision_requested do
      status { 3 }
      revision_request_date { Date.current + 7}

      factory :revision_requested_last_week do
        revision_request_date { Date.current - 7 }
      end
    end
  end
end