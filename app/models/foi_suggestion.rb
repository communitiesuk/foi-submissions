# frozen_string_literal: true

##
# This model represents an suggested answer to an FOI requests
#
class FoiSuggestion < ApplicationRecord
  belongs_to :foi_request, optional: true
  belongs_to :resource, polymorphic: true

  delegate :title, :url, :summary, :keywords, to: :resource

  def self.from_request(request)
    GenerateFoiSuggestion.from_request(request)
  end
end
