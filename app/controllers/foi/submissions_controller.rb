# frozen_string_literal: true

module Foi
  ##
  # This controller is responsible for previewing/ submitting & confirming a
  # FOI request.
  #
  class SubmissionsController < ApplicationController
    include FindableFoiRequest

    before_action :find_foi_request, only: %i[new create]
    before_action :find_sent_foi_request, only: %i[show]
    before_action :redirect_if_missing_contact
    before_action :new_submission, only: %i[new create]
    before_action :find_submission, only: %i[show]

    def new; end

    def create
      if @submission.queue
        redirect_to sent_foi_request_path
      else
        render :new
      end
    end

    def show
      @current_performance = Performance.current_percentage

      respond_to do |format|
        format.html
        format.json { render json: @submission }
      end
    end

    private

    def redirect_if_missing_contact
      return if @foi_request.contact
      redirect_to new_foi_request_contact_path
    end

    def new_submission
      @submission = @foi_request.build_submission
    end

    def find_submission
      @submission = @foi_request.submission
    end
  end
end
