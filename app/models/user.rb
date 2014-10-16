class User < ActiveRecord::Base
	
	has_secure_password

	validates :username, presence: true, uniqueness: true
	validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/ }
	validates :agency_id, presence: true
	validates :password, presence: {on: :create},length: { on: :create, minimum: 8 }
	validates_inclusion_of :role, :in => 0..2

	has_many :packages_sent, class_name: "Package", foreign_key: "sender_id"
	has_many :packages_received, class_name: "Package", foreign_key: "receiver_id"

  	belongs_to :agency

  	has_one :session

	default_scope {order(username: :asc)}
	scope :admins, -> { where(role: 2) }
	scope :operators, -> { where(role: 1) }
	scope :members, -> { where(role: 0) }


	def is_member?
		if role == 0
			return true
		else
			return false
		end
	end

	def is_operator?
		if role == 1
			return true
		else
			return false
		end
	end

	def is_admin?
		if role == 2
			return true
		else
			return false
		end
	end

	def packages
   		Package.where('sender_id = ? OR receiver_id = ?', id, id)
 	end

	# Filter user attributes to show
	def as_json(options = nil)
		super({ only: [:id, :username, :email, :role] }.merge(options || {}))
	end

end
