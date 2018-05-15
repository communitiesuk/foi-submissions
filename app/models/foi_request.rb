# frozen_string_literal: true

##
# This model represents an FOI request.
#
class FoiRequest < ApplicationRecord
  belongs_to :contact, optional: true, dependent: :destroy
  belongs_to :submission, optional: true

  validates :body, presence: true

  scope :editable, lambda {
    left_joins(:submission).
      where(submissions: { state: [nil, Submission::UNQUEUED] })
  }

  scope :sent, lambda {
    left_joins(:submission).
      where.not(submissions: { state: [nil, Submission::UNQUEUED] })
  }

  scope :delivered, lambda {
    left_joins(:submission).merge(
      Submission.delivered_successfully
    )
  }

  scope :last_updated, lambda { |time|
    where('foi_requests.updated_at < ?', time)
  }

  scope :removable, lambda {
    editable.last_updated(4.weeks.ago).or(delivered.last_updated(1.week.ago))
  }
end
