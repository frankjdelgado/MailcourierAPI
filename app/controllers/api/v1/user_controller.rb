module Api
	module V1
		class UserController < ApplicationController

			before_action :validate_token, except: ['create']
			before_filter :validate_admin, only: ['index']

			respond_to :json

			api :GET, "/user", "List users"
			formats ['json']
			error code: 401, desc: "Unauthorized. You can only access with administrators permissions."
			example ' [{"id":5,"username":"testusername","email":"test@test.com","role":2},{"id":6,"username":"testusername1","email":"test1@test.com","role":1},{"id":1,"username":"user0","email":"user0@a.com","role":0},{"id":2,"username":"user1","email":"user1@a.com","role":0},{"id":3,"username":"user2","email":"user2@a.com","role":2}] '
			def index
				users = User.all
				respond_with users.as_json , status: 200
			end

			api :POST, '/user/', 'Create an user'
			param :username, String, desc: 'Account username', required: true
			param :email, String, desc: 'Account email', required: true
			param :agency_id, :number, desc: 'Agency ID related with user', required: true
			param :password, String, desc: 'Account password. Minimun lenght must be 8', required: true
			param :password_confirmation, String, desc: 'Password confirmation', required: true
			param :role, ["0", "1", "2"], desc: 'User role inside the application. Can only be specified by an Administrator'
			formats ['json']
			error code: 400, desc: "Bad request. Parameters given are incorrect."
			error code: 401, desc: "Unauthorized. You can only access with administrators permissions."
			example ' {"id":7,"username":"testusername3","email":"test2@test.com","role":2} '
			def create

				# get requester
				# if current_user.is_admin?
					# user = User.new(admin_params)
				# else
					user = User.new(user_params)
				# end

				if user.save
					render status: :created, json: user.as_json
				else
					render status: :bad_request, json: user.errors
				end

			end

			api :GET, '/user/:id', 'Show specified user'
			param :id, :number, desc: 'User database ID', required: true
			formats ['json']
			error code: 401, desc: "Unauthorized. You can only access your own user details."
			example " {'id':3,'username':'user2','email':'user2@a.com','role':0} "
			def show
				response = Hash.new

				if current_user.id.to_s == params[:id]
					render status: :ok, json: current_user.as_json
				else
					response["error_type"] = "Invalid request"
  					response["error_description"] = "Wrong parameters to show resource"
					render status: :unauthorized, json: response
				end
			end

			api :PUT, '/user/:id', 'Update user attributes'
			param :username, String, desc: 'Account username'
			param :email, String, desc: 'Account email'
			param :agency_id, :number, desc: 'Agency ID related with user'
			param :password, String, desc: 'Account password. Minimun lenght must be 8'
			param :role, ["0", "1", "2"], desc: 'User role inside the application. Can only be specified by an Administrator'
			formats ['json']
			error code: 401, desc: "Unauthorized. You can only access with administrators permissions."
			error code: 400, desc: "Bad request. Parameters given are incorrect."
			example ' {"id":7,"username":"testusername3","email":"test2@test.com","role":2} '
			def update
				response = Hash.new
				
				if current_user.id.to_s == params[:id]

					user = User.find(params[:id])

					if user.update(user_params)
						render status: :ok, json: user.as_json
						return
					else
						render status: :unauthorized, json: user.errors
						return
					end
				else
					response["error_type"] = "Invalid request"
  					response["error_description"] = "Wrong parameters to edit resource"
					render status: :unauthorized, json: response
				end
			end


			private

			def user_params
				params.permit(:username, :email, :agency_id, :password, :password_confirmation, :role)
			end

			def admin_params
				params.permit(:username, :email, :agency_id, :password, :password_confirmation, :role)
			end

		end
	end
end
