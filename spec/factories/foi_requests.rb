# frozen_string_literal: true

FactoryBot.define do
  factory :foi_request do
    body 'How much did you spend on cycling infrastructure last year?'
    contact

    trait :unqueued do
      association :submission, :unqueued
    end

    trait :queued do
      association :submission, :queued
    end

    trait :delivered do
      association :submission, :delivered
    end
  end
end
