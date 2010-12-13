class Application < ActiveRecord::Base
	WAITING = 0
	PENDING = 1
	REACTION = 2
	FINISHED = 3
	has_many :taggable, :dependent => :destroy
	has_many :categories, :through => :taggable
	belongs_to :user
	belongs_to :closed_by, :class_name => "User", :foreign_key => "closed_by_user_id"
	belongs_to :direct_to, :class_name => "User", :foreign_key => "to_user_id"
	
	has_many :comments, :dependent => :destroy
	has_many :commenters, :class_name => "User", :foreign_key => "user_id", :through => :comments, :source => :author
	
	scope :not_closed, where("closed_by_user_id IS NULL")
	scope :is_closed, where("closed_by_user_id IS NOT NULL")
	scope :include_categories, joins({:taggable => :category})
	scope :is_viewable_by_user, lambda { |*args|
		categories_ids = args.size == 2 && !(args.last.nil? || args.last.empty?) ? args.last : args.first.categories.map(&:id)
		include_categories.where("categories.id IN (?) OR to_user_id = ? OR user_id = ? ", categories_ids, args.first.id, args.first.id)
	}
	
	scope :is_in_category, lambda { |*args|
		include_categories.where("categories.id = ", args.first)
	}
	
	validates :content, :presence => true
	
	attr_accessor :categories_ids
	
	after_save :update_categories
	
	def important?
		important == 1
	end
	
	def direct?
		!direct_to.nil?
	end
	
	def change_status(new_status, user)
		self.reaction = new_status
		
		if reaction == FINISHED
			self.closed_by_user_id = user.id
			self.close_date = Time.new
		end
		
		self.save
	end
	
	def self.format_reaction(reaction)
		if reaction == FINISHED
			return "Zakonczone"
		elsif reaction == REACTION
			return "Potrzebna dodatkowa reakcja"
		elsif reaction == PENDING
			return "Trwa wykonywanie"
		else
			return "Oczekiwanie na wykonanie"
		end
	end
	
	def reaction_text
		Application.format_reaction(reaction)
	end
	
	def closed?
		!closed_by.nil?
	end
	
	def categories_ids
		self.taggable.map(&:category_id)
	end
	
	def categories_ids=(category_ids)
		self.taggable.each(&:destroy)
		category_ids.each do |category_id|
			self.taggable.build(:category_id => category_id)
		end
	end
	
	protected
		def update_categories
			self.taggable.each(&:save)
		end
end
