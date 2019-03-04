# frozen_string_literal: true

##
# This model represents the performance percentage of the organisation
#
class Performance < ApplicationRecord
  validates :percentage, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100,
    message: 'must be between 0 and 100'
  }

  default_scope -> { order(:created_at) }
end
