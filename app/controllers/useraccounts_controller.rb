class UseraccountsController < ApplicationController
  before_action :user_login_required, only: [:index]
  def index

  end

  def show

  end
end
