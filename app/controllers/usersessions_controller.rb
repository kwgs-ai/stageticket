class UsersessionsController < ApplicationController

  def create
    user = User.find_by(login_name: params[:ID])
    if user&.authenticate(params[:password]) && cookies.signed[:actor_id].nil? && cookies.signed[:admin_id].nil?
      cookies.signed[:user_id] = user.id
      if action_name == 'show'
        redirect_to user
      else
        redirect_to session[:path]
      end
    else
      flash.alert = 'IDとパスワードが一致しません'
      flash.alert = 'すでにログイン中であるユーザーがいます。一旦ログアウトしてからログインしてください' unless cookies.signed[:admin_id].nil? && cookies.signed[:actor_id].nil?
      redirect_to :root
    end
  end

  def destroy
    cookies.delete(:user_id)
    redirect_to :root
  end
end
