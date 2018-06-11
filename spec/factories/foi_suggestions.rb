# frozen_string_literal: true

FactoryBot.define do
  factory :foi_suggestion do
    association :foi_request, strategy: :build
    association :resource, factory: :curated_link, strategy: :build
  end
end
