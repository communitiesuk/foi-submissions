# frozen_string_literal: true

require 'mysociety/validate'

##
# This model represents a contact details of an user.
#
class Contact < ApplicationRecord
  has_one :foi_request, dependent: :destroy

  validates :email, :full_name, presence: true
  validates :email, format: {
    with: /\A#{MySociety::Validate.email_match_regexp}\z/
  }
end
