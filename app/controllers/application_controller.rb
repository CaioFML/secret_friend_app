class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, :with => :render_404

  private

  def render_404
    redirect_to main_app.root_url
  end
end
