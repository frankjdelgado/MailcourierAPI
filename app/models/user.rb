class User < ActiveRecord::Base
	
	has_secure_password

	EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i

	validates :username, presence: true, uniqueness: true
	validates :email, presence: true, uniqueness: true, format: { with: EMAIL_REGEX }
	validates :agency_id, presence: true
	validates_inclusion_of :role, :in => 0..2

	default_scope {order(username: :asc)}
	scope :admins, -> { where(role: 2) }
	scope :operators, -> { where(role: 1) }
	scope :members, -> { where(role: 0) }


	def self.is_member?
		if role == 0
			return true
		else
			return false
		end
	end

	def self.is_operator?
		if role == 1
			return true
		else
			return false
		end
	end

	def self.is_admin?
		if role == 2
			return true
		else
			return false
		end
	end
	
end
