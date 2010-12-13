class CommentsController < ApplicationController
	before_filter :authenticate_user!
	before_filter :preload_resource!
  # GET /comments
  # GET /comments.xml
  def index
    redirect_to @application
  end

  def create
    @comment = @application.comments.new(params[:comment])
		@comment.user_id = self.current_user.id
		
    respond_to do |format|
      if @comment.save
        format.html { redirect_to(@application, :notice => 'Komentarz zostal dodany!') }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
				format.js
      else
        format.html { redirect_to(@application, :error => 'Nie mozna dodac komentarza!') }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
				format.js { render :js => "alert(#{@comment.errors.full_messages.join("\n").inspect});" }
      end
    end
  end

  def destroy
    @comment = self.current_user.comments.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(@application) }
      format.xml  { head :ok }
    end
  end

	protected
		def preload_resource!
			if self.current_user.role?(User::ADMIN)
				@application = Application.find(params[:application_id])
			else
				@application = Application.is_viewable_by_user(self.current_user).find(params[:application_id])
			end
		end
end
