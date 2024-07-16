FactoryBot.define do
  factory :person do
    name { "John Doe" }
    email { "john.doe@example.com" }
    phone { "123-456-7890" }
    birth_date { "1990-01-01" }
  end
end