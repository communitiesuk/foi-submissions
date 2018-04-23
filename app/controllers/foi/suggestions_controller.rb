# frozen_string_literal: true

module Foi
  ##
  # This controller is responsible for providing suggestions from previous
  # responses based on the content of a pending FOI request.
  #
  class SuggestionsController < ApplicationController
    include FindableFoiRequest

    before_action :find_foi_request

    def index; end
  end
end
