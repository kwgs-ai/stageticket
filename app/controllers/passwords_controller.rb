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

    if current_password.present?
      if @account.authenticate(current_password)
        @account.assign_attributes(params[:account])
        if @account.save
          if current_actor
            redirect_to current_actor,notice: 'パスワードを変更しました'
          elsif current_user
            redirect_to current_user,notice: 'パスワードを変更しました'
          elsif current_admin
            redirect_to current_admin,notice: 'パスワードを変更しました'
          end
        else
          @account.errors.add(:current_password, '新しいパスワードへの変更に失敗しました')
          render 'edit'
        end
      else
        @account.errors.add(:current_password, '現在のパスワードが異なります')
        render 'edit'
      end
    else
      @account.errors.add(:current_password, 'パスワードを入力してください')
      render 'edit'
    end

  end
end
