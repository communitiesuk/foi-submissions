# frozen_string_literal: true

FactoryBot.define do
  factory :submission do
    trait :unqueued do
      state Submission::UNQUEUED
    end
  end
end
