class ApplicationController < ActionController::Base
  class Actor_LoginRequired < StandardError; end

  class User_LoginRequired < StandardError; end

  class Admin_LoginRequired < StandardError; end

  rescue_from Actor_LoginRequired, with: :rescue_actor_login_required
  rescue_from User_LoginRequired, with: :rescue_user_login_required
  rescue_from Admin_LoginRequired, with: :rescue_admin_login_required

  private def actor_login_required
    session[:path] = request.fullpath
    raise Actor_LoginRequired unless current_actor
  end
  private def user_login_required
    session[:path] = request.fullpath
    raise User_LoginRequired unless current_user
  end
  private def admin_login_required
    session[:path] = request.fullpath
    raise Admin_LoginRequired unless current_admin
  end

  private def current_actor
    Actor.find_by(id: session[:actor_id]) if session[:actor_id]
  end
  helper_method :current_actor

  private def current_user
    User.find_by(id: session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  private def current_admin
    Admin.find_by(id: session[:admin_id]) if session[:admin_id]
  end
  helper_method :current_admin

  private def rescue_actor_login_required(exception)
    render "errors/actor_login_required", status: 403, layout: "error",
           formats: [:html]
  end
  private def rescue_user_login_required(exception)
    render "errors/user_login_required", status: 403, layout: "error",
           formats: [:html]
  end
  private def rescue_admin_login_required(exception)
    render "errors/admin_login_required", status: 403, layout: "error",
           formats: [:html]
  end
end
