FactoryBot.define do
  factory :user do
    name { 'Chester Butkiewicz' }
    email { 'tester@testdomain.test' }
    role { :investigator }
    region { 5 }
    office_code { 'BNG' }

    factory :supervisor do
      supervisor { true }
    end
  end

  factory :mean_supervisor, class: 'User' do
    name { 'John Smith' }
    email { 'evil@supervisor.com' }
    role { :investigator }
    supervisor { true }
  end

  factory :another_investigator, class: 'User' do
    name { 'Bob Wood' }
    email { 'testy@testdomain.test' }
    role { :investigator }
    region { 4 }
  end

  factory :cemeterian, class: 'User' do
    name { 'Bill Cemeterian' }
    role { :cemeterian }
  end

  factory :accountant, class: 'User' do
    name { 'Gus Ballard' }
    role { :accountant }
  end

  factory :support, class: 'User' do
    name { 'David Jacobson' }
    role { :support }
  end
end
