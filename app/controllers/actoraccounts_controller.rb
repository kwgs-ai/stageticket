class ActoraccountsController < ApplicationController
  before_action :actor_login_required, only: [:index]

  def index

  end

  def show
    @actor = current_actor
  end

end
