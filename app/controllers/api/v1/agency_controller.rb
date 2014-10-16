module Api
	module V1
		class AgencyController < ApplicationController

			before_action :validate_token
			before_filter :validate_admin

			respond_to :json

			api :GET, "/agency", "List agencies"
			formats ['json']
			error code: 401, desc: "Unauthorized. You can only access with administrators permissions."
			example ' [{"id":1,"location":"Location #0","created_at":"2014-10-13T08:57:31.000Z","updated_at":"2014-10-13T08:57:31.000Z"},{"id":2,"location":"Location #1","created_at":"2014-10-13T08:57:31.000Z","updated_at":"2014-10-13T08:57:31.000Z"},{"id":3,"location":"Location #2","created_at":"2014-10-13T08:57:31.000Z","updated_at":"2014-10-13T08:57:31.000Z"},{"id":4,"location":"Location #3","created_at":"2014-10-13T08:57:31.000Z","updated_at":"2014-10-13T08:57:31.000Z"},{"id":5,"location":"Location #4","created_at":"2014-10-13T08:57:31.000Z","updated_at":"2014-10-13T08:57:31.000Z"},{"id":6,"location":"Location #5","created_at":"2014-10-13T08:57:31.000Z","updated_at":"2014-10-13T08:57:31.000Z"},{"id":7,"location":"Location #6","created_at":"2014-10-13T08:57:31.000Z","updated_at":"2014-10-13T08:57:31.000Z"},{"id":8,"location":"Location #7","created_at":"2014-10-13T08:57:31.000Z","updated_at":"2014-10-13T08:57:31.000Z"},{"id":9,"location":"Location #8","created_at":"2014-10-13T08:57:31.000Z","updated_at":"2014-10-13T08:57:31.000Z"},{"id":10,"location":"Location #9","created_at":"2014-10-13T08:57:31.000Z","updated_at":"2014-10-13T08:57:31.000Z"}] '
			def index
				agencies = Agency.all
				render status: :ok, json: agencies.to_json
			end

			api :GET, "/agency/:id", "Show specified agency"
			param :id, :number, desc: 'Agency database ID', required: true
			formats ['json']
			error code: 401, desc: "Unauthorized. You can only access with administrators permissions."
			example ' {"id":1,"location":"Location #0","created_at":"2014-10-13T08:57:31.000Z","updated_at":"2014-10-13T08:57:31.000Z"} '
			def show
				agency = Agency.find(params[:id])
				render status: :ok, json: agency.to_json
			end

			api :POST, "/agency/:id", "Create an agency"
			param :location, String, desc: 'Agency location or name', required: true
			formats ['json']
			error code: 401, desc: "Unauthorized. You can only access with administrators permissions."
			error code: 400, desc: "Bad Request. Wrong parameters."
			example ' {"id":11,"location":"LocationRandom","created_at":"2014-10-16T01:27:54.550Z","updated_at":"2014-10-16T01:27:54.550Z"} '
			def create
				
				agency = Agency.new(agency_params)

				if agency.save
					render status: :ok, json: agency.to_json
				else
					render status: :bad_request, json: agency.errors
				end
			end

			api :PUT, "/agency/:id", "Update agency attributes"
			param :id, :number, desc: 'Agency database ID', required: true
			param :location, String, desc: 'Agency location or name', required: true
			formats ['json']
			error code: 401, desc: "Unauthorized. You can only access with administrators permissions."
			error code: 400, desc: "Bad Request. Wrong parameters."
			example ' {"id":11,"location":"LocationRandom2","created_at":"2014-10-16T01:27:54.000Z","updated_at":"2014-10-16T01:29:40.248Z"} '
			def update

				response = Hash.new

				agency = Agency.find_by_id(params[:id])

				if agency.blank?
					response["error_type"] = "Invalid request"
		        	response["error_description"] = "Wrong parameters to show resource"
					render status: :bad_request, json: response
					return
				else
					if agency.update(agency_params)
						render status: :ok, json: agency.to_json
					else
						render status: :bad_request, json: agency.errors
					end
				end
			end

			api :DELETE, "/agency/:id", "Delete specified agency"
			param :id, :number, desc: 'Agency database ID', required: true
			formats ['json']
			error code: 401, desc: "Unauthorized. You can only access with administrators permissions."
			error code: 400, desc: "Bad Request. Wrong parameters."
			example ' Agency deleted successfully '
			def destroy

				response = Hash.new

				agency = Agency.find_by_id(params[:id])

				if agency.blank?
					response["error_type"] = "Invalid request"
		        	response["error_description"] = "Wrong parameters to show resource"
					render status: :bad_request, json: response
					return
				end

				if agency.destroy
					render status: :ok, json: 'Agency deleted successfully'
					return
				else
					render status: :bad_request, json: agency.errors
				end
			end


			private

			def agency_params
				params.permit(:location)
			end


		end
	end
end
