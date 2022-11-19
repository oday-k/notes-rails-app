class UserController < ApplicationController
  def signup
    User.create(user_params)

    render :head, status: :created
  end

  private

  def user_params
    # Question: is there a way to enforce param types
    params.require(:user).permit(:name, :email, :password)
  end
end
