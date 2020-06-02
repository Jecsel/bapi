class V1::UserController < ApplicationController
  
  before_action :must_be_authenticated, only:[:authenticate, :get_policies, :index, :edit_user]

  def sign_in
    user = User.find_by_username user_params[:username]
    if user.present?
      if user.valid_password? user_params[:password]
        user.user_token = Generator.new().generate_alpha_numeric
        user.save
        
        bearer_token = encode({user_id: user.id,secret: user.user_token})
        render json: {token: bearer_token}
      else
        invalid_account
      end
    else
      invalid_account
    end
  end

  def authenticate
    # #return admin user information here
    render json: {message: :accepted}
  end

  def get_policies
    if !@current_user.user_role.nil?
      @policies = @current_user.user_role.user_group.role_policies.group_by(&:service_id)
    else
      render json:{message: "User has no policies"}
    end
  end

  def index
    if is_permitted?(1,1)
      @user = User.all
      @user_group = UserGroup.all
      @role_policy = @current_user.user_role.user_group.role_policies.where("role_policies.service_id = ? ",1) #User service
    else
      render json: :forbidden, status:403
    end
  end

  def edit_user
    @user = User.find edit_params[:id]
    @user.update(username: edit_params[:username])
    @user.user_role.update(user_group_id: edit_params[:user_group_id])

    @user
  end

  def sign_out

  end
  private 
  
  def invalid_account
    render json: {message:"Invalid Account"},status:403 #forbidden
    return false
  end

  def user_params
    params.require(:credential).permit(:username, :password)
  end

  def edit_params
    params.require(:user).permit(:id, :username, :user_group_id)
  end

end
