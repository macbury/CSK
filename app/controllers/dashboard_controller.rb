class DashboardController < ApplicationController
	before_filter :authenticate_user!
	
	def index
		@applications = Application.is_viewable_by_user(self.current_user, params[:category_id]).not_closed.order("important DESC, created_at DESC").paginate :per_page => 10, :page => params[:page]
	end
	
	def archive
		@applications = Application.is_viewable_by_user(self.current_user).is_closed.order("created_at DESC").paginate :per_page => 10, :page => params[:page]
	end
end
