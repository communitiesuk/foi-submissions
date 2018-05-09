# frozen_string_literal: true

##
# This worker is responsible for queuing submissions which have failed either
# because Redis was down or because a lock couldn't be acquired
#
class QueueSubmissionsWorker
  include Sidekiq::Worker

  def perform(*_args)
    Submission.queueable.find_each(&:queue)
  end
end
