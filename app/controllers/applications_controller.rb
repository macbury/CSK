class ApplicationsController < ApplicationController
	before_filter :authenticate_user!
	before_filter :preload_resource!, :only => [:index]
	before_filter :admin_required!, :only => [:reaction]
	before_filter :authorize_resource!, :only => [:show, :edit, :update, :destroy]
	
	def reaction
		@application = Application.find(params[:id])
		@application.change_status(params[:application][:reaction], self.current_user)
		
		redirect_to @application, :notice => "Zmieniono status na #{@application.reaction_text}"
	end
	
	#before_filter :categories_required!
  # GET /applications
  # GET /applications.xml
  def index
		if @user
			@applications = @user.applications.order("created_at DESC").paginate :per_page => 20, :page => params[:page]
		else
			@applications = Application.order("created_at DESC").paginate :per_page => 20, :page => params[:page]
		end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @applications }
    end
  end

  # GET /applications/1
  # GET /applications/1.xml
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @application }
    end
  end

  # GET /applications/new
  # GET /applications/new.xml
  def new
    @application = Application.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @application }
    end
  end

  # GET /applications/1/edit
  def edit
  end

  # POST /applications
  # POST /applications.xml
  def create
    @application = self.current_user.applications.new(params[:application])

    respond_to do |format|
      if @application.save
        format.html { redirect_to(@application, :notice => 'Application was successfully created.') }
        format.xml  { render :xml => @application, :status => :created, :location => @application }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @application.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /applications/1
  # PUT /applications/1.xml
  def update

    respond_to do |format|
      if @application.update_attributes(params[:application])
        format.html { redirect_to(@application, :notice => 'Application was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @application.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /applications/1
  # DELETE /applications/1.xml
  def destroy
    @application.destroy

    respond_to do |format|
      format.html { redirect_to(applications_url) }
      format.xml  { head :ok }
    end
  end
	protected
		def authorize_resource!
			if self.current_user.role?(User::ADMIN)
				@application = Application.find(params[:id])
			else
				@application = Application.is_viewable_by_user(self.current_user).find(params[:id])
			end
		end
		
		def preload_resource!
			if params[:user_id]
				@user = User.find(params[:user_id])
			else
				admin_required!
			end
		end
end
