# frozen_string_literal: true

##
# This controller concern finds an FOI request and sets @foi_request.
#
# Requires an :request_id parameter.
#
module FindableFoiRequest
  extend ActiveSupport::Concern

  included do
    private

    def find_foi_request
      @foi_request = foi_request_from_session(scope: FoiRequest.editable)
      redirect_if_missing_request
    end

    def find_sent_foi_request
      @foi_request = foi_request_from_session(scope: FoiRequest.sent)
      redirect_if_missing_request
    end

    def foi_request_from_session(scope: FoiRequest.all)
      scope.
        includes(:contact).
        references(:contact).
        find_by(id: session[:request_id])
    end

    def redirect_if_missing_request
      return if @foi_request
      redirect_to new_foi_request_path
    end

    def store_foi_request_in_session
      session[:request_id] = @foi_request.id
    end

    def current_foi_request?(foi_request)
      foi_request == foi_request_from_session
    end
  end
end
