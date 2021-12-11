class ApplicationController < ActionController::Base
  class Actor_LoginRequired < StandardError; end

  rescue_from Actor_LoginRequired, with: :rescue_actor_login_required

  private def actor_login_required
    raise Actor_LoginRequired
  end


  private def rescue_actor_login_required(exception)
    render "errors/login_required", status: 403, layout: "error",
           formats: [:html]
  end
end
