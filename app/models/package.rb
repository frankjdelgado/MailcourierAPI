class Package < ActiveRecord::Base

	validates :ref_number, presence: true, uniqueness: true
	validates :description, presence: true
	validates :weight, presence: true, numericality: true
	validates :height, presence: true, numericality: true
	validates :depth, presence: true, numericality: true
	validates :width, presence: true, numericality: true
	validates :value, presence: true, numericality: true
	validates :shipping_cost, presence: true, numericality: true
	validates :status, presence: true, numericality: true
	validates :agency_id, presence: true, numericality: true
	validates :receiver_id, presence: true, numericality: true
	validates :sender_id, presence: true, numericality: true

	belongs_to :receiver, class_name: "User", foreign_key: "receiver_id"
	belongs_to :sender, class_name: "User", foreign_key: "sender_id"
	belongs_to :agency

	default_scope {order(status: :asc)}
	scope :pending, -> { where(status: 0) }
	scope :arrived, -> { where(status: 1) }
	scope :delivered, -> { where(status: 2) }
	scope :agency_pending, -> { where.not(status: 2)}

	def status_human
		if status == 0
			I18n.t('pending')
		elsif status == 1
			I18n.t('arrived')
		else
			I18n.t('delivered')
		end	
	end

	def is_pending?
		if status == 0
			return true
		else
			return false
		end
	end

	def is_arrived?
		if status == 1
			return true
		else
			return false
		end
	end

	def is_delivered?
		if status == 2
			return true
		else
			return false
		end
	end

	# Search form by ref number
	def self.search_by_package(terms)
    	where('ref_number= ?',terms) 
  	end

  	# Search form by username
  	def self.search_by_user(terms)
  		# where('receiver.username = ?', terms)
    	joins(:sender,:receiver).where('receivers_packages.username = ? OR users.username = ?',terms,terms)
  	end

end
