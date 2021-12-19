class UsersessionsController < ApplicationController

  def create
    user = User.find_by(login_name: params[:ID])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      if action_name == "show"
        redirect_to user
        else
        redirect_to session[:path]
      end
    else
      flash.alert = "IDとパスワードが一致しません"
      redirect_to :root
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to :root
  end
end
