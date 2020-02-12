FactoryBot.define do
  factory :member do
    name { "MyString" }
    email { "MyString" }
    campaign { nil }
    open { false }
    token { "MyString" }
  end
end
