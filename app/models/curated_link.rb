# frozen_string_literal: true

# Resources added by staff that appear in the Suggestions to users.
class CuratedLink < ApplicationRecord
  validates :title, :url, presence: true

  def keywords
    self[:keywords].to_s.split
  end
end
