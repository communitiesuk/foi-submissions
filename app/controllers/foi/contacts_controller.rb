# frozen_string_literal: true

module Foi
  ##
  # This controller is responsible for creating and updating contact details of
  # a FOI requester.
  #
  class ContactsController < ApplicationController
    include FindableFoiRequest

    before_action :find_foi_request
    before_action :redirect_if_exisiting_contact, only: %i[new create]
    before_action :new_contact, only: %i[new create]
    before_action :find_contact, only: %i[edit update]

    def new; end

    def create
      if @contact.update(contact_params)
        redirect_to preview_foi_request_path
      else
        render :new
      end
    end

    def edit; end

    def update
      if @contact.update(contact_params)
        redirect_to preview_foi_request_path
      else
        render :edit
      end
    end

    private

    def redirect_if_exisiting_contact
      return unless @foi_request.contact
      redirect_to edit_foi_request_contact_path
    end

    def new_contact
      @contact = @foi_request.build_contact
    end

    def find_contact
      @contact = @foi_request.contact
    end

    def contact_params
      params.require(:contact).permit(:full_name, :email)
    end
  end
end
