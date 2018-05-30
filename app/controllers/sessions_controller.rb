# frozen_string_literal: true

##
# This controller is responsible for handling OminAuth callbacks
#
class SessionsController < ApplicationController
  def new
    render plain: ''
  end

  def create
    session[:current_user] = user.uid
    session[:current_provider] = provider
    session[:authenticated_until] = expires_at

    redirect_to session[:redirect_to] || admin_root_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

  def user
    User.find_or_create_with_omniauth(auth_hash)
  end

  def provider
    auth_hash.provider
  end

  def expires_at
    auth_hash.credentials.expires_at
  end
end
