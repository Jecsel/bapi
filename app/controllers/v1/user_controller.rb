class V1::UserController < ApplicationController

  def sign_in

  end

  def authenticate

  end

  def sign_out

  end
  private 

  def user_params
    params.require(:credential).permit(:username, :password)
  end
  
end
