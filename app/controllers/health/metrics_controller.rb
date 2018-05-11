# frozen_string_literal: true

module Health
  ##
  # This controller is responsible for providing an overview of system metrics
  # for internal monitoring checks
  #
  class MetricsController < ApplicationController
    layout false

    def index
      @sidekiq_stats = Sidekiq::Stats.new
    end
  end
end
