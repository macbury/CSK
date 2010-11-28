class Category < ActiveRecord::Base
	has_many :ownerships, :dependent => :destroy
	has_many :users, :through => :ownerships
	
	has_many :taggable, :dependent => :destroy
	has_many :applications, :through => :taggable
end
