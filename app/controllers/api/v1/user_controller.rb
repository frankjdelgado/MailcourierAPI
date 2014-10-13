module Api
	module V1
		class UserController < ApplicationController

			before_action :validate_token

			respond_to :json

			def index
				users = User.all
				respond_with users.as_json , status: 200
			end

			def create

				response = Hash.new

				# get requester
				if current_user.is_admin?
					user = User.new(admin_params)
				else
					user = User.new(user_params)
				end

				if user.save
					render status: :created, json: user.as_json
				else
					response["error_type"] = "Invalid request"
  					response["error_description"] = "Wrong parameters to create resource"
					render status: :bad_request, json: response
				end

			end


			private

			def user_params
				params.permit(:username, :email, :agency_id, :password, :password_confirmation)
			end

			def admin_params
				params.permit(:username, :email, :agency_id, :password, :password_confirmation, :role)
			end

		end
	end
end
