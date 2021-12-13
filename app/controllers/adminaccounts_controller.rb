class AdminaccountsController < ApplicationController
  before_action :admin_login_required, only: [:index]
  def index

  end
  def show
    @actor = current_admin
  end
end
