module ApplicationHelper
	
	def role?(role)
		logged_in? && self.current_user.role?(role)
	end
	
end
