module Api
	module V1
		class RateController < ApplicationController

			before_action :validate_token
			before_filter :validate_admin, :only => [:new, :create, :update, :destroy, :index, :show, :edit]

			respond_to :json

			def calculate

				response = Hash.new

				if params[:height].blank? || params[:width].blank? || params[:depth].blank? || params[:value].blank? || params[:weight].blank?
					response["error_type"] = "Invalid request"
		        	response["error_description"] = "Wrong parameters to process resource"
		        	render status: :bad_request, json: response
		        	return
				end

				# Get shipping cost
				shipping_cost = get_shipping_cost(params[:height],params[:weight],params[:depth],params[:width],params[:value])
				
				response["shipping_cost"] = shipping_cost

				render status: :ok, json: response

			end

			def index
				rates = Rate.all
				respond_with rates.as_json , status: 200
			end

			def show

				response = Hash.new

				rate = Rate.find_by_id(params[:id])

				if rate
					render status: :ok, json: rate.as_json				
				else
					response["error_type"] = "Invalid request"
		        	response["error_description"] = "Wrong parameters to show resource"
					render status: :bad_request, json: response
				end

			end

			def create
				response = Hash.new

				rate = Rate.new(rate_params)

		        if rate.save
		        	render status: :created, json: rate.as_json
		        else
		        	response["error_type"] = "Invalid request"
		        	response["error_description"] = "Wrong parameters to create resource"
					render status: :bad_request, json: response
		        end
			end

			def update

				response = Hash.new

				rate = Rate.find_by_id(params[:id])

				if rate.blank?
					response["error_type"] = "Invalid request"
			        response["error_description"] = "Wrong parameters to update resource"
			        render status: :bad_request, json: response
			        return
				end


				if params[:package]
					rate.package = params[:package]
				end

				if params[:cost]
					rate.cost = params[:cost]
				end

				if params[:status]
					rate.status = 1
				end

				# Get Current active
				active = Rate.active.first

				if !active.blank? && active.id != rate.id
					# Deactivate
					active.status = 0
					if !active.save
						response["error_type"] = "Server error"
			        	response["error_description"] = "Couln't process your request"
			        	render status: :internal_server_error, json: response
			        	return
					end					
				end

				if rate.save
					render status: :ok, json: rate.as_json
					return
				else
					response["error_type"] = "Invalid request"
		        	response["error_description"] = "Wrong parameters to update resource"
		        	render status: :bad_request, json: response
				end
				
			end

			def destroy

				response = Hash.new

				rate = Rate.inactive.find_by_id(params[:id])

				if rate && rate.destroy
			        response["message"] = "Rate deleted successfully"
					render status: :ok, json: response
				else
					response["error_type"] = "Invalid request"
			        response["error_description"] = "Wrong parameters to destroy resource"
			        render status: :bad_request, json: response
				end
			end

			private

			def rate_params
				params.permit(:package, :cost)
			end

		end
	end
end
