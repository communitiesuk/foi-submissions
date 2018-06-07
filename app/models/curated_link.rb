# frozen_string_literal: true

# Resources added by staff that appear in the Suggestions to users.
class CuratedLink < ApplicationRecord
  validates :title, :url, presence: true

  scope :active, -> { where(destroyed_at: nil) }

  def soft_destroy
    update(destroyed_at: Time.zone.now)
  end
end
