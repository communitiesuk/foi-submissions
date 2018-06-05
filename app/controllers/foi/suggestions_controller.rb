# frozen_string_literal: true

module Foi
  ##
  # This controller is responsible for providing suggestions from previous
  # responses based on the content of a pending FOI request.
  #
  class SuggestionsController < ApplicationController
    include FindableFoiRequest

    before_action :find_foi_request

    def index
      @suggestions = GenerateFoiSuggestion.from_request(@foi_request)
      redirect_to new_foi_request_contact_path if @suggestions.empty?
    end
  end
end
