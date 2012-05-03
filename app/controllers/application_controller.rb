require'manual_auth'

class ApplicationController < ActionController::Base
  protect_from_forgery
protected
  def current_user_email
    session['auth'].try(:[], 'info').try(:[], 'email')
  end
  def need_view!
    unless ManualAuth.email_ok_for?(current_user_email, ManualAuth::VIEW) or
      ManualAuth.email_ok_for?(current_user_email, ManualAuth::EDIT) or
      ManualAuth.email_ok_for?(current_user_email, ManualAuth::ADMIN)
      flash[:warn] = "You must be logged in to see that."
      redirect_to('/')
    end
  end
  def need_edit!
    unless ManualAuth.email_ok_for?(current_user_email, ManualAuth::EDIT) or
      ManualAuth.email_ok_for?(current_user_email, ManualAuth::ADMIN)
      flash[:warn] = "You must be logged in as an editor to access that."
      redirect_to('/')
    end
  end
  def need_admin!
    unless ManualAuth.email_ok_for?(current_user_email, ManualAuth::ADMIN)
      flash[:warn] = "You must be logged in as an administrator to access that."
      redirect_to('/')
    end
  end
end

