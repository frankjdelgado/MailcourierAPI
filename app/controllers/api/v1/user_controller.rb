module Api
	module V1
		class UserController < ApplicationController

			def index
				users = User.all
				render json:  users.as_json , status: 200
			end

		end
	end
end
