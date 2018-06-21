# frozen_string_literal: true

FactoryBot.define do
  factory :resource do
    association :resource, factory: :curated_link, strategy: :build
  end
end
