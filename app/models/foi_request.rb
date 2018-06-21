# frozen_string_literal: true

##
# This model represents an FOI request.
#
class FoiRequest < ApplicationRecord
  belongs_to :contact, optional: true, dependent: :destroy
  belongs_to :submission, optional: true

  has_many :foi_suggestions, dependent: :nullify

  validates :body, presence: true

  scope :editable, lambda {
    left_joins(:submission).merge(
      # Find submissions which haven't been queued or where submission hasn't
      # been created yet, this works as we're using a left join.
      Submission.queueable.or(Submission.where(id: nil))
    )
  }

  scope :sent, lambda {
    left_joins(:submission).merge(
      Submission.deliverable.or(Submission.delivered)
    )
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
