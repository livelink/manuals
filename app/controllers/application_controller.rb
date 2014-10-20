require'manual_auth'

class ApplicationController < ActionController::Base
  protect_from_forgery
  def gravatar
	  c = HTTPClient.new
	  res = c.get("http://www.gravatar.com/avatar/#{params[:hash]}?s=80&r=g")
	  headers['Content-Type'] = res.content_type
	  render :text => res.content, :type => res.content_type, :layout => false
  end
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

