# frozen_string_literal: true

##
# This service will deliver the associated submission request to the council,
# normally their case management software
#
class DeliverSubmission < SimpleDelegator
  delegate :contact, to: :foi_request

  def call
    request = Infreemation::Request.create!(attributes)
    update(
      state: Submission::DELIVERED,
      reference: request.attributes[:ref]
    )
  end

  private

  def attributes
    {
      rt: 'create',
      type: 'FOI',
      requester: contact.full_name,
      contact: contact.email,
      contacttype: 'email',
      body: foi_request.body
    }
  end
end
