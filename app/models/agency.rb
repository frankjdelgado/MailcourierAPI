class Agency < ActiveRecord::Base

	validates :location, presence: true, uniqueness: true

	has_many :packages
end
