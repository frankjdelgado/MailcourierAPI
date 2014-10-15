module Api
	module V1
		class SessionController < ApplicationController

			respond_to :json

			# Show user oauth token by basic auth
			def index

				response = Hash.new

				user = User.where(username: request.headers["username"]).first

				if user.authenticate(request.headers["password"])
					response["token"] = user.session.token
					render status: :ok, json: response
				else
					render status: :bad_request, json: user.errors
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
						render status: :internal_server_error, json: session.errors
						return
					end

				else
					render status: :bad_request, json: user.errors
					return 
				end

			end

		end
	end
end