FactoryBot.define do
  factory :campaign do
    title { "MyString" }
    description { "MyText" }
    user { nil }
    status { 1 }
  end
end
