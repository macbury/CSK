class Comment < ActiveRecord::Base
	belongs_to :author, :class_name => "User", :foreign_key => "user_id"
	belongs_to :application
	
	default_scope order("created_at ASC")
	
	validates :body, :presence => true
	
	after_create :send_notification
	
	def send_notification
		commenters = self.application.commenters.group("dm_user.id").where("dm_user.id != ?", self.author.id).all
		
		commenters.each do |commenter|
			Notifications.new_comment(self, commenter).deliver
		end
		
	end
end
