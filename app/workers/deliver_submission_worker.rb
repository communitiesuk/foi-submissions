# frozen_string_literal: true

##
# This worker is responsible for sending Requests to case management platforms
#
class DeliverSubmissionWorker
  include Sidekiq::Worker

  def perform(id)
    submission = Submission.deliverable.find_by(id: id)
    submission&.deliver
  end
end
