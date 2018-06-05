# frozen_string_literal: true

##
# This controller is responsible for tracking the number of clicks on suggested
# resources
#
class LinksController < ApplicationController
  include FindableFoiRequest

  def show
    suggestion = FoiSuggestion.find(params[:id])
    suggestion.clicked! if current_foi_request?(suggestion.foi_request)
    redirect_to suggestion.url
  end
end
