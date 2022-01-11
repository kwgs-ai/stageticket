class ApplicationController < ActionController::Base
  class Actor_LoginRequired < StandardError; end

  class User_LoginRequired < StandardError; end

  class Admin_LoginRequired < StandardError; end

  class Forbidden < StandardError; end

  if Rails.env.production? || ENV['RESCUE_EXCEPTIONS']
    rescue_from StandardError, with: :rescue_internal_server_error
    rescue_from ActiveRecord::RecordNotFound, with: :rescue_not_found
    rescue_from ActionController::ParameterMissing, with: :rescue_bad_request
  end

  rescue_from Forbidden, with: :rescue_forbidden


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
    Actor.find_by(id: cookies.signed[:actor_id]) if cookies.signed[:actor_id]
  end
  helper_method :current_actor

  private def current_user
    User.find_by(id: cookies.signed[:user_id]) if cookies.signed[:user_id]
  end
  helper_method :current_user

  private def current_admin
    Admin.find_by(id: cookies.signed[:admin_id]) if cookies.signed[:admin_id]
  end
  helper_method :current_admin

  private def rescue_actor_login_required(exception)
    render 'errors/actor_login_required', status: 403, layout: 'error',
                                          formats: [:html]
  end
  private def rescue_user_login_required(exception)
    render 'errors/user_login_required', status: 403, layout: 'error',
                                         formats: [:html]
  end
  private def rescue_admin_login_required(exception)
    render 'errors/admin_login_required', status: 403, layout: 'error',
                                          formats: [:html]
  end

  private def rescue_bad_request(exception)
    render 'errors/bad_request', status: 400, layout: 'error',
                                 formats: [:html]
  end

  private def rescue_forbidden(exception)
    render 'errors/forbidden', status: 403, layout: 'error',
                               formats: [:html]
  end

  private def rescue_not_found(exception)
    render 'errors/not_found', status: 404, layout: 'error',
                               formats: [:html]
  end

  private def rescue_internal_server_error(exception)
    render 'errors/internal_server_error', status: 500, layout: 'error',
                                           formats: [:html]
  end

end
