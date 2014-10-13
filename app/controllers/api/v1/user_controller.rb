module Api
	module V1
		class UserController < ApplicationController

			respond_to :json

			def index
				users = User.all
				respond_with users.as_json , status: 200
			end

			def create
				
			end

		end
	end
end
