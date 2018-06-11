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

    factory :foi_request_with_suggestions do
      after(:create) do |foi_request, _evaluator|
        create_list(:foi_suggestion, 3, foi_request: foi_request)
      end
    end
  end
end
