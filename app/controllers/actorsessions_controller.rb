class ActorsessionsController < ApplicationController

  def create
    actor = Actor.find_by(login_name: params[:ID])
    if actor&.authenticate(params[:password])
      session[:actor_id] = actor.id
      if action_name == "show"
        redirect_to actor
      else
        redirect_to session[:path]
      end

    else
      flash.alert = "IDとパスワードが一致しません"
      redirect_to :root
    end
  end

  def destroy
    session.delete(:actor_id)
    redirect_to :root
  end
end

