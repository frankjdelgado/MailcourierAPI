module Api
	module V1
		class AgencyController < ApplicationController

			before_action :validate_token
			before_filter :validate_admin

			def index
				agencies = Agency.all
				render status: :ok, json: agencies.to_json
			end

			def show
				agency = Agency.find(params[:id])
				render status: :ok, json: agency.to_json
			end

			def create

				response = Hash.new

				agency = Agency.new(agency_params)

				if agency.save
					render status: :ok, json: agency.to_json
				else
					response["error_type"] = "Invalid request"
		        	response["error_description"] = "Wrong parameters to show resource"
					render status: :bad_request, json: response
				end
			end

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
						response["error_type"] = "Invalid request"
			        	response["error_description"] = "Wrong parameters to show resource"
						render status: :bad_request, json: response
					end
				end
			end

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
					response["error_type"] = "Invalid request"
		        	response["error_description"] = "Wrong parameters to show resource"
					render status: :bad_request, json: response
				end
			end


			def agency_params
				params.permit(:location)
			end


		end
	end
end
