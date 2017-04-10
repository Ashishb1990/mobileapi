class Api::V1::RegistrationsController < Api::V1::ApiController

# User Registration APi
#   Url : http://localhost:3000/api/v1/sign_up
#   type : post
#   Parameters: { "email": "ashish1@gmail.com","password":"12345678","password_confirmation":"12345678"}
def create
  if params[:email].nil? && params[:password].nil? && params[:password_confirmation].nil?
    render :status=>401, :json=>{:message=>"Email or password can't be blank !"}
  else
    email = User.find_by_email(params[:email])
    if email.present?
     render :status=>401, :json=>{:message=>"Email is already exist !"}
    else
    if params[:password] == params[:password_confirmation]
      user = User.new(:email => params[:email], :password=> params[:password], :password_confirmation=> params[:password])
      if user.save
        render :status=>200, :json=>{:message=>"success", :user=>user}
      else
        render :status=>401, :json=>{:message=>"false"}
      end
    else
      render :status=>401, :json=>{:message=>"Password does not match !"}
    end
   end
  end  
end

def destroy
end

# Api For: Change Email
# Method:  POST
# URL: http://localhost:3000/api/v1/update_account?user_token=BMggmozss3ww1rBsbYYM
# Header: { Content-Type: application/json, User-Token: zLF4sg6RwHkhKkFvhPyy }
# Parameter: {"type":"email","email": "ashish11@gmail.com","confirm_email":"ashish11@gmail.com"}

def update
  if params[:type].nil?
    render :status=>400, :json=>{:message=>"Type can't be blank ?"}
  elsif params[:type].to_s == "email" || params[:type] == "EMAIL"
    if params[:email].nil? && params[:confirm_email].nil?
      render :status=>401, :json=>{:message=>"Email or confirm email can't be blnak !"} 
    else
      if params[:email].to_s == params[:confirm_email].to_s
        @user = current_user.update(email: params[:email])
        # @user.save
        render :status=>200, :json=>{:message=>"success"} 
      else
        render :status=>401, :json=>{:message=>"Email or confirm email is not correct!"}
      end 
    end
  elsif params[:type].to_s == "password" || params[:type] == "PASSWORD"
    if params[:password].nil? && params[:password_confirmation].nil?
      render :status=>401, :json=>{:message=>"Email or confirm email can't be blnak !"} 
    else
      if params[:password].to_s == params[:password_confirmation].to_s
        @user = current_user.update(password: params[:password])
        # @user.save
        render :status=>200, :json=>{:message=>"success"} 
      else
        render :status=>401, :json=>{:message=>"Email or confirm email is not correct!"}
      end 
    end
  end
end 


 # Api For: Reset Password 
  # Method: GET
  # Header: { Content-Type: application/json }
  # Url: http://localhost:3000/api/v1/reset_password?email=ashish1234@mailinator.com
  # Parameter: { } 

  def reset_password
    if params[:email].nil? 
      render :status=>400,:json=>{:message=>"The request must contain the user email "}
      return
    end
    @user = User.find_by_email(params[:email])
    if @user.present?
      @user.send_reset_password_instructions
      render :status=>200, :json=>{:status => true,:message=>'New Password has been sent on your email'}
    else
      render :status=>401, :json=>["mail not exist"]
    end
  end
 
end
