# frozen_string_literal: true

FactoryBot.define do
  factory :submission do
    trait :unqueued do
      state Submission::UNQUEUED
    end

    trait :queued do
      state Submission::QUEUED
    end

    trait :delivered do
      state Submission::DELIVERED
      sequence :reference do |n|
        "FOI-#{n}"
      end
    end
  end
end
