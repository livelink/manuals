class SessionsController < ApplicationController
  def create
    #@user = User.find_or_create_from_auth_hash(auth_hash)
    #self.current_user = @user
	session['auth'] = auth_hash
    redirect_to '/'
  end
  def destroy
    session['auth'] = nil
	redirect_to '/'
  end
  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
