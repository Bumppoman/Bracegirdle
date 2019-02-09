FactoryBot.define do
  factory :user do
    name { 'Chester Butkiewicz' }
    email { 'tester@testdomain.test' }
    password { 'pa$$word' }
    role { 2 }
  end

  factory :mean_supervisor, class: 'User' do
    name { 'John Smith' }
    email { 'evil@supervisor.com' }
    password { 'test' }
    role { 4 }
  end
end