# frozen_string_literal: true

##
# This service will deliver the associated submission request to the council,
# normally their case management software
#
class DeliverSubmission < SimpleDelegator
  def call
    # FIXME: actually submit Request
    update(state: Submission::DELIVERED, reference: "FOI-#{rand(100)}")
  end
end
