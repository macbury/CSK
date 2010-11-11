class DashboardController < ApplicationController
	before_filter :authenticate_user!
	
	def index
		render :text => "Hello world!!!"
	end
end
