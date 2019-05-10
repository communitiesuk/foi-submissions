# frozen_string_literal: true

##
# This controller is responsible for authentication users to the admin interface
#
class AdminController < ApplicationController
  before_action :authenticate
  before_action :set_cache_buster

  helper_method :current_user

  def show; end

  private

  def authenticate
    return if authenticate?

    session[:redirect_to] = request.fullpath if request.method == 'GET'
    redirect_to '/auth/google'
  end

  def authenticate?
    current_user && authenticated_until > Time.zone.now
  end

  def current_user
    return unless session[:current_user]
    @current_user ||= User.find_by(uid: session[:current_user])
  end

  def authenticated_until
    Time.zone.at(session[:authenticated_until].to_i)
  end

  def set_cache_buster
    response.headers['Cache-Control'] = 'no-store, must-revalidate'
  end
end
