# frozen_string_literal: true

module Admin
  ##
  # This controller is responsible for allowing staff to add CuratedLinks that
  # appear in the Suggestions to users.
  #
  class CuratedLinksController < AdminController
    def index
      @curated_links = CuratedLink.all
    end

    def new
      @curated_link = CuratedLink.new
    end

    def create
      @curated_link = CuratedLink.new

      if @curated_link.update(curated_link_params)
        redirect_to admin_curated_links_path,
                    notice: 'Curated Link successfully created'
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
        redirect_to admin_curated_links_path,
                    notice: 'Curated Link successfully updated'
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
