require 'digest/md5'
class User < ActiveRecord::Base
	NORMAL = 0
	STAFF = 1
	ADMIN = 2
	ITOA64 = './0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
	has_many :ownerships, :dependent => :destroy
	has_many :categories, :through => :ownerships
	
	has_many :comments, :dependent => :destroy
	
	attr_protected :role, :password, :salt
	
	set_table_name "dm_user"
	
	def role_name
		if role?(User::NORMAL)
			"Normalny"
		elsif role?(User::STAFF)
			"Ekipa"
		else
			"Admin"
		end
	end
	
	def role?(role_index)
		self.role == role_index
	end
	
	def self.authenticate(params)
		pass = params[:password].strip
		user = User.find_by_email(params[:username])
		if user && User.phpbb_check_hash(pass, user.password)
			user
		else
			false
		end
	end
	
	def self.phpbb_check_hash(password, hash)
		itoa64 = User::ITOA64
		if hash.size == 34
			return (User._hash_crypt_private(password, hash, itoa64) == hash) ? true : false
		else
			return (Digest::MD5.hexdigest(password) == hash) ? true : false
		end
	end
	
	def self._hash_crypt_private(password, setting, itoa64)
		output = '*'
		if setting[0,3] != '$H$'
			return output
		end
		
		count_log2 = itoa64.index(setting[3])
		if count_log2 < 7 || count_log2 > 30
			return output
		end
		
		count = 1 << count_log2
		e_salt = setting[4,8]
		
		if e_salt.size != 8
			return output
		end
		
		hash = Digest::MD5.digest(e_salt + password)
		
		count.times do
			hash = Digest::MD5.digest(hash + password)
		end
		
		output = setting[0,12]+User.encode_64(hash, 16)
		
		return output
	end
	
	def self.encode_64(input, length)
	  output = "" 
	  i = 0
	  while i < length
	    value = input[i].ord
	    i+=1
	    break if value.nil?
	    output += User::ITOA64[value.ord & 0x3f, 1]
	    value |= input[i].ord << 8 if i < length
	    output += User::ITOA64[(value.ord >> 6) & 0x3f, 1]

	    i+=1
	    break if i >= length
	    value |= input[i].ord << 16 if i < length
	    output += User::ITOA64[(value.ord >> 12) & 0x3f,1]

	    i+=1
	    break if i >= length
	    output += User::ITOA64[(value.ord >> 18) & 0x3f,1]
	  end
	  output
	end
	

end
