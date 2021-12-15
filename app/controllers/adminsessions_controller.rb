class AdminsessionsController < ApplicationController
  def create
    admin = Adminaccount.find_by(admin_ID: params[:ID])
    if admin&.authenticate(params[:password])
      session[:admin_id] = admin.id
      if action_name == "show"
        redirect_to admin
      else
        redirect_to session[:path]
      end
    else
      flash.alert = "IDとパスワードが一致しません"
      redirect_to :root
    end
  end

  def destroy
    session.delete(:admin_id)
    redirect_to :root
  end
end
