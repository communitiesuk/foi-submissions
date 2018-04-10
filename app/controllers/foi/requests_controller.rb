# frozen_string_literal: true

module Foi
  ##
  # This controller is responsible for creating and updating of FOI requests.
  #
  class RequestsController < ApplicationController
    before_action :new_foi_request, only: %i[new create]

    def index; end

    def new; end

    def create
      if @foi_request.update(foi_request_params)
        redirect_to foi_request_suggestions_path(@foi_request)
      else
        render :new
      end
    end

    def edit; end

    def update; end

    private

    def new_foi_request
      @foi_request = FoiRequest.new
    end

    def foi_request_params
      params.require(:foi_request).permit(:body)
    end
  end
end
