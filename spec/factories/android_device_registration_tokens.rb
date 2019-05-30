FactoryBot.define do
  factory :android_device_registration_token do
    token { Faker::Lorem.word }
    association :user
  end
end
