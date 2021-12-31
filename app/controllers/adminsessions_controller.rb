class AdminsessionsController < ApplicationController
  def create
    admin = Admin.find_by(login_name: params[:ID])
    if admin&.authenticate(params[:password]) && session[:user_id].nil? && session[:actor_id].nil?
      session[:admin_id] = admin.id
      if action_name == 'show'
        redirect_to admin
      else
        redirect_to session[:path]
      end
    else
      flash.alert = 'IDとパスワードが一致しません'
      flash.alert = 'すでにログイン中であるユーザーがいます。一旦ログアウトしてからログインしてください'  unless session[:user_id].nil? && session[:actor_id].nil?
      redirect_to :root
    end
  end

  def destroy
    session.delete(:admin_id)
    redirect_to :root
  end
end
