# frozen_string_literal: true

module Foi
  ##
  # This controller is responsible for previewing/ submitting & confirming a
  # FOI request.
  #
  class SubmissionsController < ApplicationController
    include FindableFoiRequest

    def new; end

    def create
      redirect_to foi_request_sent_path(@foi_request)
    end

    def show; end
  end
end
