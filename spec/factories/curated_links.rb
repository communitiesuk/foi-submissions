# frozen_string_literal: true

FactoryBot.define do
  factory :curated_link do
    title 'Existing information for 2018'
    url 'https://www.example.com/2018/existing-information'

    trait :with_summary do
      summary <<-TEXT.strip_heredoc
      This is a short (optional) summary of the information published at the URL
      of this curated link.
      TEXT
    end

    factory :curated_link_with_suggestions do
      after(:create) do |curated_link, _evaluator|
        create_list(:foi_suggestion, 3, resource: curated_link)
      end
    end
  end
end
