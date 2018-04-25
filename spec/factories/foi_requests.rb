# frozen_string_literal: true

FactoryBot.define do
  factory :foi_request do
    body 'How much did you spend on cycling infrastructure last year?'
    contact

    trait :unqueued do
      submission
    end
  end
end
