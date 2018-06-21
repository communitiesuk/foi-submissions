# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    provider 'google'
    uid 'SC937-0176 CEC'
    name 'James T. Kirk'
    email 'kirk@example.com'
  end
end
