module Api
	module V1
		class RateController < ApplicationController

			before_action :validate_token
			before_filter :validate_admin, :only => [:new, :create, :update, :destroy, :index, :show, :edit]

			respond_to :json

			api :GET, "/rate/calculate", "Calculate package shipping cost"
			formats ['json']
			param :weight, :number, desc: 'Package weight', required: :true
			param :height, :number, desc: 'Package height', required: :true
			param :width, :number, desc: 'Package width', required: :true
			param :depth, :number, desc: 'Package depth', required: :true
			param :value, :number, desc: 'Package value', required: :true
			error code: 400, desc: "Bad request. Wrong parameters."
			example ' {"shipping_cost":1173.06} '
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

			api :GET, "/rate", "List Mailcourier package rates"
			formats ['json']
			error code: 401, desc: "Unauthorized. You can only access with administrators permissions."
			example ' [{"id":2,"package":10.5,"cost":30.2,"status":1},{"id":1,"package":80.6474,"cost":28.8981,"status":0},{"id":3,"package":39.0257,"cost":22.1477,"status":0},{"id":4,"package":67.7276,"cost":34.1744,"status":0}] '
			def index
				rates = Rate.all
				respond_with rates.as_json , status: 200
			end

			api :GET, "/rate/:id", "Show specified package rate"
			formats ['json']
			param :id, :number, desc: 'Package database ID', required: :true
			example ' {"id":1,"package":80.6474,"cost":28.8981,"status":0} '
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

			api :POST, "/rate", "Create package rates. Default status 0"
			formats ['json']
			param :cost, :number, desc: 'Package value rate', required: :true
			param :package, :number, desc: 'Package dimension rate', required: :true
			error code: 401, desc: "Unauthorized. You can only access with administrators permissions."
			error code: 400, desc: "Bad request. Wrong parameters."
			example ' {"id":5,"package":10.0,"cost":10.0,"status":0} '
			def create

				rate = Rate.new(rate_params)

		        if rate.save
		        	render status: :created, json: rate.as_json
		        else
					render status: :bad_request, json: rate.errors
		        end
			end

			api :PUT, "/rate/:id", "Update specified package rates attributes"
			formats ['json']
			param :id, :number, desc: 'Package database ID'
			param :cost, :number, desc: 'Package value rate'
			param :package, :number, desc: 'Package dimension rate'
			param :status, ["0","1"], desc: 'Package rate status. Active/inactive'
			error code: 401, desc: "Unauthorized. You can only access with administrators permissions."
			error code: 400, desc: "Bad request. Wrong parameters."
			example ' {"id":5,"package":12.0,"cost":12.0,"status":1} '
			def update

				response = Hash.new

				rate = Rate.find_by_id(params[:id])

				if rate.blank?
					response["error_type"] = "Invalid request"
			        response["error_description"] = "Wrong parameters to update resource"
			        render status: :bad_request, json: rate.errors
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
			        	render status: :internal_server_error, json: active.errors
			        	return
					end					
				end

				if rate.save
					render status: :ok, json: rate.as_json
					return
				else
		        	render status: :bad_request, json: rate.errors
				end
				
			end

			api :DELETE, "/rate/:id", "Delete specified package rates"
			formats ['json']
			param :id, :number, desc: 'Package database ID'
			error code: 401, desc: "Unauthorized. You can only access with administrators permissions."
			error code: 400, desc: "Bad request. Wrong parameters or rate is currently active"
			example ' {"message":"Rate deleted successfully"} '
			def destroy

				response = Hash.new

				rate = Rate.find_by_id(params[:id])

				if !rate
					response["error_type"] = "Invalid request"
  					response["error_description"] = "Wrong parameters to find resource"
					render status: :bad_request, json: response
					return
				end

				if rate && rate.destroy
			        response["message"] = "Rate deleted successfully"
					render status: :ok, json: response
				else
			    	render status: :bad_request, json: rate.errors
				end
			end

			private

			def rate_params
				params.permit(:package, :cost)
			end

		end
	end
end
