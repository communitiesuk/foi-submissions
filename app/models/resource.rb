# frozen_string_literal: true

##
# Union of CuratedLink and PublishedRequest powered by a Postgres view
#
class Resource < ApplicationRecord
  belongs_to :resource, polymorphic: true

  delegate :foi_suggestions, :id, :created_at, :updated_at, to: :resource
  delegate :shown, :click_rate, :answer_rate, to: :statistics

  def self.csv_columns
    %i[id title url keywords
       shown click_rate answer_rate
       created_at updated_at]
  end

  private

  def statistics
    @statistics ||= OpenStruct.new(foi_suggestions.statistics)
  end
end
