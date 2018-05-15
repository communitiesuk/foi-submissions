# frozen_string_literal: true

module Admin
  ##
  # This controller is responsible for allowing staff to add CuratedLinks that
  # appear in the Suggestions to users.
  #
  class CuratedLinksController < ApplicationController
    def index
      @curated_links = CuratedLink.all
    end

    def new
      @curated_link = CuratedLink.new
    end

    def create
      @curated_link = CuratedLink.new

      if @curated_link.update(curated_link_params)
        redirect_to edit_admin_curated_link_path(@curated_link)
      else
        render :new
      end
    end

    def edit
      @curated_link = CuratedLink.find(params[:id])
    end

    def update
      @curated_link = CuratedLink.find(params[:id])

      if @curated_link.update(curated_link_params)
        redirect_to edit_admin_curated_link_path(@curated_link)
      else
        render :edit
      end
    end

    private

    def curated_link_params
      params.require(:curated_link).permit(:title, :url, :summary, :keywords)
    end
  end
end
