class ApplicationController < ActionController::Base
  protect_from_forgery
	helper_method :logged_in?, :current_user
	protected
		def authenticate_user!
			redirect_to login_path, :notice => "Musisz byc zalogowany!" unless logged_in?
		end
		
		def logged_in?
			!self.current_user.nil?
		end
		
		def current_user
			@current_user ||= User.find(session[:user_id]) if session[:user_id]
			@current_user
		end
		
		def admin_required!
			redirect_to root_path, :notice => "Brak tu wstepu dla ludzi i kobiet" unless (logged_in? && self.current_user.role?(User::ADMIN))
		end
		
		def categories_required!
			redirect_to root_path, :notice => "Musisz miec przypisana chociaz jedna kategorie!" unless (logged_in? && self.current_user.categories.size > 0)
		end
end
