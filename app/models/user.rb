require 'digest/md5'
class User < ActiveRecord::Base
	NORMAL = 0
	STAFF = 1
	ADMIN = 2
	has_many :ownerships, :dependent => :destroy
	has_many :categories, :through => :ownerships
	
	has_many :comments, :dependent => :destroy
	
	attr_protected :role
	
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
		pass = Digest::MD5.hexdigest(params[:password].strip)
		user = User.find_by_login(params[:login])
		if user #&& User.phpbb_check_hash(pass, "")
			user
		else
			false
		end
	end
	
	def self.phpbb_check_hash(password, hash)
		itoa64 = './0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
		if hash.size == 34
			return (User._hash_crypt_private(password, hash, itoa64) === hash) ? true : false
		else
			return (Digest::MD5.hexdigest(password) === hash) ? true : false
		end
	end
	
	def self._hash_crypt_private(password, setting, itoa64)
		output = '*'
		
		if setting[0..3] != '$H$'
			return output
		end
		
		count_log2 = itoa64.index(setting[3])
		
		if count_log2 < 7 || count_log2 > 30
			return output
		end
		
		count = 1 << count_log2
		salt = setting[4..8]
		
		if salt.size != 8
			return output
		end
		
		hash = Digest::MD5.hexdigest(salt + password)
		
		while (count > 0)
			hash = Digest::MD5.hexdigest(hash + password)
		end
		output = setting[0..12]
		output += User._hash_encode64(hash, 16, itoa64);
		
		return output
	end
	
	def self._hash_encode64(input, count, itoa64)
		output = ''
		i = 0
		
		while i < count
			i += 1
			value = input[i].ord
			output += itoa64[value & 0x3f]
			
			if i < count
				value |= input[i].ord << 8
			end
			
			output += itoa64[(value >> 6) & 0x3f]
			i += 1
			
			break if i >= count

			value |= input[i].ord << 16 if i < count
			
			output += itoa64[(value >> 12) & 0x3f]
			
			i += 1
			break if i >= count
			output += itoa64[(value >> 18) & 0x3f]
		end
		
		return output
	end
	

end
