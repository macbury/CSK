class ApplicationController < ActionController::Base
  protect_from_forgery

	protected
		def authenticate_user!
			redirect_to login_path unless logged_in?
		end
		
		def logged_in?
			!self.current_user.nil?
		end
		
		def current_user
			@current_user ||= User.find(session[:user_id]) if session[:user_id]
			@current_user
		end
		
		def admin_required!
			redirect_to root_path unless (logged_in? && self.current_user.role?(User::ADMIN))
		end
end
