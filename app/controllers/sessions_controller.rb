class SessionsController < ApplicationController
	def new
		@session = User.new
		
		respond_to do |format|
			format.html
		end
	end
	
	def create
		@session = User.authenticate(params[:user])
		
		if @session
			session[:user_id] = @session.id
			flash[:notice] = "Zostale poprawnie zalogowny"
			respond_to do |format|
				format.html { redirect_to root_path }
			end
			
		else
			@session = User.new
			flash[:error] = "Nieprawidlowy login lub haslo"
			
			respond_to do |format|
				format.html { render :action => "new" }
			end
		end
	end
	
	def destroy
		session.delete(:user_id)
		respond_to do |foramt|
			format.html { redirect_to root_path, :notice => "Zosta;es wylogowany" }
		end
	end
end
