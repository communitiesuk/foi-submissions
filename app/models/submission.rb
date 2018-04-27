# frozen_string_literal: true

##
# This model represents the state of a submission to external case management
# software.
#
class Submission < ApplicationRecord
  UNQUEUED = 'unqueued'

  has_one :foi_request, dependent: :destroy

  validates :state, presence: true
end
