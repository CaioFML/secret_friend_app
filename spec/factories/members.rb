FactoryBot.define do
  factory :member do
    association :campaign, strategy: :create

    name         { FFaker::Lorem.word }
    email        { FFaker::Internet.email }
  end
end
