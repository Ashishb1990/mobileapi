class Api::V1::SessionsController < Api::V1::ApiController

 #User sing_in Api
 #url: http://localhost:3000/api/v1/sign_in
 #type : post
 #parameters:{"email":"ashish11@gmail.com","password":"12345678"}
  def create
		email = params[:email]
    password = params[:password]
    if request.format != :json
      render :status=>406, :json=>{:message=>"The request must be json"}
      return
    end

    if email.nil? and password.nil?
      render :status=>400,
      :json=>{:message=>"The request must contain the user email and password."}
      return
    end

    @user=User.find_by_email(email.downcase)

    if @user.blank?
      logger.info("User #{email} failed signin, user cannot be found.")
      render :status=>401, :json=>{:message=>"Invalid email or passoword."}
      return
    end
     if not @user.valid_password?(password)
      logger.info("User #{email} failed signin, password \"#{password}\" is invalid")
      render :status=>401, :json=>{:message=>"Invalid email or password."}
    else
      sign_in("user", @user)
      render :status=>200, :json=>{:status => true,:user=>@user
        }
     end
  end


#user sing_out
#url :http://localhost:3000/api/v1/sign_out
#type :delete
  def destroy
  	if request.format != :json
      render :status=>406, :json=>{:message=>"The request must be json"}
      return
    end    
    if  Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)        
      render :status=>200, :json=>{:message=>"Success"}
      return
    else
      render :status=>406, :json=>{:message=>"0"}
      return
    end
 end
  

end
