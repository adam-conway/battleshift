FactoryBot.define do
  factory :user do
    name "Adam"
    email "adam.n.conway@gmail.com"
    authenticated false
    api_key "123456789a"
    password "password"
  end
end
