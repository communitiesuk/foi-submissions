# frozen_string_literal: true

##
# This model represents an FOI request.
#
class FoiRequest < ApplicationRecord
  belongs_to :contact, optional: true, dependent: :destroy
  belongs_to :submission, optional: true, dependent: :destroy

  validates :body, presence: true

  scope :unqueued, lambda {
    left_joins(:submission).
      where(submissions: { state: [nil, Submission::UNQUEUED] })
  }
end
