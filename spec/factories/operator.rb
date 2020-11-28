FactoryBot.define do
  factory :operator do
    crematory_cemid { '38999' }
    name { 'Joseph Ambrose' }
    certification_date { Date.current }
    certification_expiration_date { Date.current + 5.years }
  end
end
