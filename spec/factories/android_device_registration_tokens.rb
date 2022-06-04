# frozen_string_literal: true

FactoryBot.define do
  factory :android_device_registration_token do
    token { Faker::Lorem.word }
    association :user
  end
end
