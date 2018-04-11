# frozen_string_literal: true

##
# This controller concern finds an FOI request and sets @foi_request.
#
# Requires an :request_id parameter.
#
module FindableFoiRequest
  extend ActiveSupport::Concern

  included do
    before_action :set_foi_request

    private

    def set_foi_request
      @foi_request = FoiRequest.find(params.require(:request_id))
    end
  end
end
