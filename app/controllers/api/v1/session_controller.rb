module Api
	module V1
		class SessionController < ApplicationController

			respond_to :json

			api :GET, "/session", "Show user oauth token using basic auth"
			param :username, String, 'HTTP Header parameter. Required'
			param :password, String, 'HTTP Header parameter. Required'
			formats ['json']
			error code: 400, desc: "Bad request. Username or password are invalid."
			example ' {"token":"0J3tZTMLGG4eFOXkKbcD2MNcFAXyeBrNvSqp1/W8Ea01hJKaiEsgCirSm/mblhx9K5ftIDAAFtNteJ5A9khe3g=="} '
			def index

				response = Hash.new

				user = User.where(username: request.headers["username"]).first

				if !user or !user.session
					response["error_type"] = "Invalid request"
		        	response["error_description"] = "Wrong parameters to find session token."
		        	render status: :bad_request, json: response
		        	return
				end

				if user.authenticate(request.headers["password"])
					response["token"] = user.session.token
					response["username"] = user.username
					response["role"] = user.role
					render status: :ok, json: response
				else
					render status: :bad_request, json: user.errors
				end

			end

			api :POST, "/session", "Generate oauth token using basic auth"
			param :username, String, 'HTTP Header parameter. Required'
			param :password, String, 'HTTP Header parameter. Required'
			formats ['json']
			error code: 400, desc: "Bad request. Username or password are invalid/missing."
			example ' {"token":"SlNvy/H3jXt/lavoxdki2ftWgv7Yo/svgyzAhEPnb0j+94SKCLXlk+B+D96ckpHLGzEgoQc7IM7IqAW3oYboLw=="} '
			def create

				response = Hash.new

				# Get user
				user = User.where(username: request.headers["username"]).first

				if !user
					response["error_type"] = "Invalid request"
		        	response["error_description"] = "Wrong parameters to find session token."
		        	render status: :bad_request, json: response
		        	return
				end

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
						response["username"] = user.username
						response["role"] = user.role
						render status: :created, json: response
						return
					else
						render status: :internal_server_error, json: session.errors
						return
					end

				else
					response["error_type"] = "Invalid request"
		        	response["error_description"] = "Wrong parameters to authenticate resource"
		        	render status: :bad_request, json: response
					return 
				end

			end

		end
	end
end