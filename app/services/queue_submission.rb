# frozen_string_literal: true

##
# This service queues the submission worker and updates the submission state. It
# also handles any errors connecting to the Redis instance.
#
class QueueSubmission < SimpleDelegator
  def call
    success = ActiveRecord::Base.transaction do
      begin
        # double update otherwise `id` can be nil
        update(state: Submission::QUEUED)
        update(job_id: DeliverSubmissionWorker.perform_async(id))
      rescue Redis::BaseConnectionError
        raise ActiveRecord::Rollback
      end
    end

    update(state: Submission::UNQUEUED) unless success

    true
  end
end
