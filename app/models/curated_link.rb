# frozen_string_literal: true

##
# Resources added by staff that appear in the Suggestions to users.
#
class CuratedLink < ApplicationRecord
  has_many :foi_suggestions, as: :resource, dependent: :destroy

  validates :title, :url, presence: true

  scope :active, -> { where(destroyed_at: nil) }

  delegate :shown, :click_rate, :answer_rate, to: :statistics

  def statistics
    @statistics ||= OpenStruct.new(foi_suggestions.statistics)
  end

  def self.csv_columns
    %i[id title url keywords shown click_rate answer_rate created_at updated_at]
  end

  def soft_destroy
    update(destroyed_at: Time.zone.now)
  end
end
