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
  end
end
