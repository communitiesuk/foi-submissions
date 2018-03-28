# frozen_string_literal: true

##
# This model represents a contact details of an user.
#
class Contact < ApplicationRecord
  has_one :foi_request, dependent: :destroy

  validates :email, :full_name, presence: true
end
