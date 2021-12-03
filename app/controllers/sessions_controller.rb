class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user&.authenticate(params[:session][:password])
      #Log in and redirect to user page
      log_in @user
      #nu merge. Chiar daca nu se creeaza user id si remember token, tot nu se delogheaza
      params[:session][:remember_me] == '1' ? remember(@user) :forget(@user)
      redirect_to @user
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
