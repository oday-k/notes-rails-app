class UserController < ApplicationController
  def signup
    User.create(user_params)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
