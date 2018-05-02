# frozen_string_literal: true

##
# This worker is responsible for sending Requests to case management platforms
#
class DeliverSubmissionWorker
  include Sidekiq::Worker
  include Sidekiq::Lock::Worker

  sidekiq_options lock: {
    timeout: 30.seconds.in_milliseconds,
    name: proc { |id, _timeout| "lock:submission_worker:#{id}" }
  }

  def perform(id)
    submission = Submission.deliverable.find_by(id: id)
    return unless lock.acquire!

    begin
      submission&.deliver
    ensure
      lock.release!
    end
  end
end
