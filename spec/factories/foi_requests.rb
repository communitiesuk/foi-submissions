# frozen_string_literal: true

FactoryBot.define do
  factory :foi_request do
    body 'How much did you spend on cycling infrastructure last year?'
    contact
    submission
  end
end
