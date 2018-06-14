# frozen_string_literal: true

module Admin
  ##
  # This controller is responsible for exporting admin data
  #
  class ExportsController < AdminController
    def show
      respond_to do |format|
        format.csv  { render csv: CuratedLink.all }
      end
    end
  end
end
