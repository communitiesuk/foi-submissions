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
      set_foi_request
      redirect_if_missing_request
    end

    def set_foi_request
      @foi_request = FoiRequest.
                     includes(:contact).
                     references(:contact).
                     find_by(id: params.require(:request_id))
    end

    def redirect_if_missing_request
      return if @foi_request
      redirect_to new_foi_request_path
    end
  end
end
