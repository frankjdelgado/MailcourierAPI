class Session < ActiveRecord::Base
  belongs_to :user
  validates :token, presence: true, uniqueness: true

	def as_json(options = nil)
		super({ only: [:token] }.merge(options || {}))
	end

end
