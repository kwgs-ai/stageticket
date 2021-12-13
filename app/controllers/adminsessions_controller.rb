class AdminsessionsController < ApplicationController
  def create
    admin = Adminaccount.find_by(admin_ID: params[:ID])
    if admin&.authenticate(params[:password])
      session[:admin_id] = admin.id
      redirect_to admin
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
