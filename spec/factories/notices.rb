 FactoryBot.define do
  factory :notice do
    cemetery_county { 4 }
    cemetery_cemid { '04001' }
    trustee_id { 1 }
    served_on_street_address { '1313 Mockingbird Ln.' }
    served_on_city { 'Rotterdam' }
    served_on_state { 'NY' }
    served_on_zip { '12345' }
    law_sections { 'Testing.' }
    specific_information { 'Testing.' }
    violation_date { Date.current }
    response_required_date { Date.current + 14 }
    investigator_id { 1 }
  end
end