# frozen_string_literal: true

##
# This worker purges old FOI requests from the database
#
class CleanRequestsWorker
  include Sidekiq::Worker

  def perform(*_args)
    FoiRequest.removable.destory_all
  end
end
