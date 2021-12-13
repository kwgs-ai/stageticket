class AdminaccountsController < ApplicationController
  before_action :admin_login_required, only: [:index]

  def index
    @stages = Stage.where(status: false)
  end

  def show
    @admin = current_admin
  end
end
