# frozen_string_literal: true

module Foi
  ##
  # This controller is responsible for creating and updating of FOI requests.
  #
  class RequestsController < ApplicationController
    include FindableFoiRequest

    before_action :new_foi_request, only: %i[new create]
    before_action :find_foi_request, only: %i[edit update]

    def index; end

    def new; end

    def create
      if @foi_request.update(foi_request_params)
        store_foi_request_in_session
        redirect_to foi_request_suggestions_path
      else
        render :new
      end
    end

    def edit; end

    def update
      if @foi_request.update(foi_request_params)
        redirect_to foi_request_suggestions_path
      else
        render :edit
      end
    end

    private

    def new_foi_request
      @foi_request = FoiRequest.new
    end

    def foi_request_params
      params.require(:foi_request).permit(:body)
    end
  end
end
