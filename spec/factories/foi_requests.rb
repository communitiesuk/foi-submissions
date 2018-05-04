# frozen_string_literal: true

FactoryBot.define do
  factory :foi_request do
    body 'How much did you spend on cycling infrastructure last year?'
    association :contact, strategy: :build

    trait :unqueued do
      association :submission, :unqueued, strategy: :build
    end

    trait :queued do
      association :submission, :queued, strategy: :build
    end

    trait :delivered do
      association :submission, :delivered, strategy: :build
    end
  end
end
