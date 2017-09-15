class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource_or_scope)
    current_user.admin? ? customers_url : current_user.customer? ? customer_path(current_user) : staff_path(current_user)
  end

  def permission_denied
    render :file => "public/401.html", :status => :unauthorized, :layout => false
  end

end
