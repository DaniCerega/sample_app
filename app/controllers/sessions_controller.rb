class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user&.authenticate(params[:session][:password])
      #Log in and redirect to user page
      if @user.activated?
        log_in @user
        #nu merge. Chiar daca nu se creeaza user id si remember token, tot nu se delogheaza
        params[:session][:remember_me] == '1' ? remember(@user) :forget(@user)
        redirect_back_or @user
      else
        message = "Account not activated. "
        message += "Check your email for the activation link." 
        flash[:warning] = message
        redirect_to root_url
end
    else
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
