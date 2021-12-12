class ApplicationController < ActionController::Base
  class Actor_LoginRequired < StandardError; end
  class User_LoginRequired < StandardError; end

  rescue_from Actor_LoginRequired, with: :rescue_actor_login_required
  rescue_from User_LoginRequired, with: :rescue_user_login_required

  private def actor_login_required
    raise Actor_LoginRequired
  end
  private def user_login_required
    raise User_LoginRequired
  end

  private def current_actor
    Actoraccount.find_by(id: session[:actor_id]) if session[:actor_id]
  end
  helper_method :current_actor

  private def current_user
    Useraccount.find_by(id: session[:actor_id]) if session[:user_id]
  end
  helper_method :current_user

  private def rescue_actor_login_required(exception)
    render "errors/actor_login_required", status: 403, layout: "error",
           formats: [:html]
  end
  private def rescue_user_login_required(exception)
    render "errors/user_login_required", status: 403, layout: "error",
           formats: [:html]
  end
end
