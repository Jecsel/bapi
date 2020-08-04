class V1::UserController < ApplicationController
  
  before_action :must_be_authenticated, only:[:authenticate, :get_policies, :index, :edit_user, :create]

  def sign_in
    user = User.find_by_username user_params[:username]
    if user.present?
      if user.valid_password? user_params[:password]
        if user.is_active
          if !user.first_login
            user.user_token = Generator.new().generate_alpha_numeric
            user.save
            
            bearer_token = encode({user_id: user.id,secret: user.user_token})
            render json: {token: bearer_token}
          else
            set_new_pass(user)
          end
        else
          invalid_account  
        end
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
      @user = User.get_list_by_role(@current_user.user_role.user_group.id)
      @user_group = UserGroup.get_by_role(@current_user.user_role.user_group.id)
      @role_policy = @current_user.user_role.user_group.role_policies.where("role_policies.service_id = ? ",1) #User service
    else
      render json: :forbidden, status:403
    end
  end

  def edit_user
    @user = User.find edit_params[:id]
    
    if @user.is_active != !edit_params[:is_active].zero?
      AuditLog.log_changes("Users", "user_status", @user.id, @user.is_active, edit_params[:is_active], 1, @current_user.username)
    end

    @user.update(is_active: edit_params[:is_active])
    if @user.user_role.present?
      old_value = @user.user_role.user_group.name
      @user.user_role.update(user_group_id: edit_params[:user_group_id]) 
    else
      old_value = nil
      @user.user_role = UserRole.create(user_id: @user.id, user_group_id: edit_params[:user_group_id])
    end
    if old_value != @user.user_role.user_group.name
      AuditLog.log_changes("Users", "user_role", @user.user_role.id, old_value, @user.user_role.user_group.name, 1, @current_user.username)
    end

    @user
  end

  def create
    if !User.exists?(username: create_params[:username])
      temp_pass = rand.to_s[2..7] 

      @user           = User.new
      @user.username  = create_params[:username]
      @user.password  = temp_pass
      @user.email     = create_params[:email]
      @user.is_active = create_params[:status]
  
      if @user.save!
        UserRole.create(user_id: @user.id, user_group_id: create_params[:user_group_id])
        AuditLog.log_changes("Users", "user_add", @user.id, "", @user.username, 0, @current_user.username)
        AdminMailer.new_user(@user, request.host, temp_pass).deliver_later
      end
      render json: {user: @user}
    else
      render json: {message: "Username already exists."}
    end
    
  end

  def sign_out

  end

  def update_pass
    user = User.find_by_username params[:user]
    user.update(first_login: false)
    user.update(password: Digest::MD5.hexdigest(params[:pass])[0..19])

    bearer_token = encode({user_id: user.id,secret: user.user_token})

    render json: {message: "Password updated successfully", token: bearer_token}
  end

  private 
  

  def set_new_pass user
    render json: {message:"Set new password"}
    return false
  end

  def invalid_account
    render json: {message:"Invalid Account"},status:403 #forbidden
    return false
  end

  def user_params
    params.require(:credential).permit(:username, :password)
  end

  def edit_params
    params.require(:user).permit(:id, :username, :user_group_id, :is_active)
  end

  def create_params
    params.require(:user).permit(:username, :email, :status, :user_group_id)
  end

end
