class ActorsessionsController < ApplicationController

  def create
    actor = Actor.find_by(login_name: params[:ID])
    if actor&.authenticate(params[:password]) && cookies.signed[:user_id].nil? && cookies.signed[:admin_id].nil?
      cookies.signed[:actor_id] = actor.id
      if action_name == 'show'
        redirect_to actor
      else
        redirect_to session[:path]
      end
    else
      flash.alert = 'IDとパスワードが一致しません'
      flash.alert = 'すでにログイン中であるユーザーがいます。一旦ログアウトしてからログインしてください'  unless cookies.signed[:user_id].nil? && cookies.signed[:admin_id].nil?
      redirect_to :root
    end
  end

  def destroy
    cookies.delete(:actor_id)
    redirect_to :root
  end
end

