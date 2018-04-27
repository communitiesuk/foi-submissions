# frozen_string_literal: true

module Foi
  ##
  # This controller is responsible for previewing/ submitting & confirming a
  # FOI request.
  #
  class SubmissionsController < ApplicationController
    include FindableFoiRequest

    before_action :find_foi_request
    before_action :redirect_if_missing_contact

    def new; end

    def create
      redirect_to sent_foi_request_path
    end

    def show; end

    private

    def redirect_if_missing_contact
      return if @foi_request.contact
      redirect_to new_foi_request_contact_path
    end
  end
end
