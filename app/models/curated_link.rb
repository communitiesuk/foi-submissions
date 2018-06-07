# frozen_string_literal: true

# Resources added by staff that appear in the Suggestions to users.
class CuratedLink < ApplicationRecord
  validates :title, :url, presence: true

  def soft_destroy
    update(destroyed_at: Time.zone.now)
  end
end
