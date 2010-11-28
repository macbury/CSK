class OwnershipsController < ApplicationController
	before_filter :authenticate_user!, :admin_required!, :preload_resources
	
	def index
		@owners = @category.users.all
		@users = User.limit(40).all
	end
	
	def create
		@user = User.find(params[:user_id])
		@ownership = Ownership.find_or_create_by_user_id_and_category_id(@user.id, @category.id)
		
		render :partial => "ownerships/owner", :object => @user
	end
	
	def destroy
		@user = User.find(params[:id])
		@ownership = @category.ownerships.find_by_user_id(@user.id)
		@ownership.destroy
		
		render :partial => "ownerships/user", :object => @user
	end
	
	protected
		def preload_resources
			@category = Category.find(params[:category_id])
		end
end
