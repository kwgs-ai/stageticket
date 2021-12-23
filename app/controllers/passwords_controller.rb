class PasswordsController < ApplicationController
  def edit
    if current_admin
      @account = current_admin
    elsif current_actor
      @account = current_actor
    elsif current_user
      @account = current_user
    end
  end

  def show
    if current_actor
      redirect_to :actor
    elsif current_user
      redirect_to :user
    elsif current_admin
      redirect_to :admin
    end

  end

  def update
    if current_admin
      @account = current_admin
    elsif current_actor
      @account = current_actor
    elsif current_user
      @account = current_user
    end
    current_password = params[:account][:current_password]

    if current_password.present?
      if @account.authenticate(current_password)
        @account.assign_attributes(params[:account])
        if @account.save
          if current_actor
            redirect_to current_actor
          elsif current_user
            redirect_to current_user
          elsif current_admin
            redirect_to current_admin
          end
        else
          render "edit"
        end
      else
        @account.errors.add(:current_password, :wrong)
        render "edit"
      end
    else
      @account.errors.add(:current_password, :empty)
      render "edit"
    end

  end
end
