class ApplicationController < ActionController::Base
  protect_from_forgery

protected
  def require_admin_role
    unless current_user.admin?
      flash[:error] = "You are not authorized"
      redirect_to home_path
    end
  end
end
