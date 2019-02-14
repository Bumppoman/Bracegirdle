FactoryBot.define do
  factory :user do
    name { 'Chester Butkiewicz' }
    email { 'tester@testdomain.test' }
    password { 'pa$$word' }
    role { 2 }
    region { 5 }

    factory :supervisor do
      role { 4 }
    end
  end

  factory :mean_supervisor, class: 'User' do
    name { 'John Smith' }
    email { 'evil@supervisor.com' }
    password { 'pa$$word' }
    role { 4 }
  end

  factory :another_investigator, class: 'User' do
    name { 'Bob Wood' }
    email { 'testy@testdomain.test' }
    password { 'pa$$word' }
    role { 2 }
  end
end