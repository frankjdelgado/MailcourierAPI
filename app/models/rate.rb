class Rate < ActiveRecord::Base

	validates :package, presence: true, numericality: true
	validates :cost, presence: true, numericality: true
	validates :status, inclusion: { in: 0..1 }

	default_scope {order(status: :desc)}
	scope :active, -> { where(status: 1) }
	scope :inactive, -> { where(status: 0) }

	def is_active?
		if status == 1
			return true
		else
			return false
		end
	end

	def as_json(options = nil)
		super({ only: [:id, :package, :cost, :status] }.merge(options || {}))
	end
	
end
