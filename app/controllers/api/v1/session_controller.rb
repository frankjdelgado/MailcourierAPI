module Api
	module V1
		class SessionController < ApplicationController

			respond_to :json

			# Show user oauth token
			def index

				response = Hash.new

				user = User.where(username: request.headers["username"]).first

				if user.authenticate(request.headers["password"])
					respond_with session.as_json , status: 200
				else
					response["error_type"] = "Invalid basic auth"
      				response["error_description"] = "Invalid user or password"
					render status: :bad_request, json: response
				end

			end

			# Generate oauth token by basic auth
			def create

				response = Hash.new

				# Get user
				user = User.where(username: request.headers["username"]).first

				# Check user password
				if user.authenticate(request.headers["password"])

					# IF user has already an Oauth token, delete it
					if user.session
						user.session.delete
					end

					session = Session.new(token: generate_token)
					session.user = user

					if session.save
						response["token"] = session.token
						render status: :created, json: response
						return
					else
						response["error_type"] = "Server error"
      					response["error_description"] = "Server couldn't create oauth token"
						render status: :internal_server_error, json: response
						return
					end

				else
					response["error_type"] = "Invalid basic auth"
      				response["error_description"] = "Invalid user or password"
					render status: :bad_request, json: response
					return 
				end

			end

		end
	end
end