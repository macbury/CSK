class Notification < ActionMailer::Base
  default :from => "macbury@gmail.com"

	def new_comment(comment, email)
		@comment = comment
		mail(:to => email, :subject => t('notifications.new_comment.subject'))
	end
end
