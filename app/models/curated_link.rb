# frozen_string_literal: true

# Resources added by staff that appear in the Suggestions to users.
class CuratedLink < ApplicationRecord
  has_many :foi_suggestions, as: :resource, dependent: :destroy

  validates :title, :url, presence: true

  delegate :shown, :click_rate, :answer_rate, to: :statistics

  def statistics
    @statistics ||= OpenStruct.new(foi_suggestions.statistics)
  end
end
