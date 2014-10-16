module Api
	module V1
		class PackageController < ApplicationController

			before_action :validate_token
			before_filter :validate_operator, :only => [:new, :create, :update, :destroy]

			respond_to :json

			api :GET, "/package", "List user packages. If user is an operator, the endpoint will show all packages related to his agency."
			formats ['json']
			param :ref_number, String, desc: 'Filter: Package reference number'
			param :username, String, desc: 'Filter: Package sender/receiver username. Can only be used by operators.'
			error code: 401, desc: "Unauthorized. You can only access with operator permissions."
			example ' [{"id":1,"ref_number":"MC-a94eac9f0867a4fba101","description":"package0","weight":30.1852,"height":17.1054,"depth":1.44668,"width":88.9232,"value":17.9698,"shipping_cost":99.6356,"status":0,"agency_id":1,"date_added":null,"date_arrived":null,"date_delivered":null,"sender_id":2,"receiver_id":1,"created_at":"2014-10-13T08:57:32.000Z","updated_at":"2014-10-13T08:57:32.000Z"},{"id":6,"ref_number":"itj6Lnu3QwIgya89Nyq9bxFBCWVRLhz7WabG/otrOc1qMdYa1C/o4xIzz55nbPP6YLppDUmHF3R+MdrmZsDG/A==","description":"asd","weight":10.0,"height":10.0,"depth":10.0,"width":10.0,"value":10.0,"shipping_cost":955.4,"status":0,"agency_id":1,"date_added":"2014-10-14T12:32:39.000Z","date_arrived":null,"date_delivered":null,"sender_id":1,"receiver_id":3,"created_at":"2014-10-14T12:32:39.000Z","updated_at":"2014-10-14T12:32:39.000Z"},{"id":7,"ref_number":"RT42BdZMmnXESQ2kLdnn2e0rbmVOPMMUvPvmamVjoIYrFvk3Zx9dS6Z89JRwftCEtq6GDIkqRG/35ewd//TG9w==","description":"asd","weight":10.0,"height":10.0,"depth":10.0,"width":10.0,"value":10.0,"shipping_cost":955.4,"status":0,"agency_id":1,"date_added":"2014-10-14T12:32:43.000Z","date_arrived":null,"date_delivered":null,"sender_id":1,"receiver_id":2,"created_at":"2014-10-14T12:32:43.000Z","updated_at":"2014-10-14T12:32:43.000Z"},{"id":8,"ref_number":"MC-97528ba590a8880f99f0","description":"asd","weight":10.0,"height":10.0,"depth":10.0,"width":10.0,"value":10.0,"shipping_cost":955.4,"status":0,"agency_id":1,"date_added":"2014-10-14T12:35:41.000Z","date_arrived":null,"date_delivered":null,"sender_id":1,"receiver_id":2,"created_at":"2014-10-14T12:35:41.000Z","updated_at":"2014-10-14T12:35:41.000Z"},{"id":9,"ref_number":"MC-e7b943d21b5412c853f0","description":"asd","weight":10.0,"height":10.0,"depth":10.0,"width":10.0,"value":10.0,"shipping_cost":955.4,"status":0,"agency_id":1,"date_added":"2014-10-14T12:35:44.000Z","date_arrived":null,"date_delivered":null,"sender_id":1,"receiver_id":2,"created_at":"2014-10-14T12:35:44.000Z","updated_at":"2014-10-14T12:35:44.000Z"}] '
			def index

				if current_user.is_member?
					packages = current_user.packages
					if params[:ref_number]
						packages = packages.where(ref_number: params[:ref_number])
					end
				else
					packages = current_user.agency.packages.agency_pending
					if params[:username]
						packages = Package.search_by_user(params[:username])
					end
					if params[:ref_number]
						packages = Package.where(ref_number: params[:ref_number])
					end
				end

				render status: :ok, json: packages.to_json
			end


			api :GET, "/package", "Show specified package. If user is a member, it will only show packages related to him."
			formats ['json']
			param :id, :number, desc: 'Package database ID'
			example ' {"id":2,"ref_number":"MC-f640505999e450294eb4","description":"package1","weight":21.8673,"height":80.323,"depth":69.3697,"width":7.47692,"value":31.216,"shipping_cost":29.7139,"status":2,"agency_id":8,"date_added":null,"date_arrived":"2014-10-14T12:51:44.000Z","date_delivered":"2014-10-14T12:52:40.000Z","sender_id":1,"receiver_id":2,"created_at":"2014-10-13T08:57:32.000Z","updated_at":"2014-10-14T12:52:40.000Z"} '
			def show
				if current_user.is_member?
					package = current_user.packages.find_by_id(params[:id])
				else
					package = Package.find_by_id(params[:id])
				end
				render status: :ok, json: package
			end

			api :POST, "/package", "Create package"
			formats ['json']
			param :weight, :number, desc: 'Package weight', required: :true
			param :height, :number, desc: 'Package height', required: :true
			param :width, :number, desc: 'Package width', required: :true
			param :depth, :number, desc: 'Package depth', required: :true
			param :value, :number, desc: 'Package value', required: :true
			param :agency_id, :number, desc: 'Package destination id', required: :true
			param :sender_id, :number, desc: 'Package user sender id', required: :true
			param :receiver_id, :number, desc: 'Package user receiver id', required: :true
			param :description, String, desc: 'Package short description', required: :true
			error code: 401, desc: "Unauthorized. You can only access with operator permissions."
			error code: 400, desc: "Bad request. Parameters given are incorrect."
			example ' {"id":10,"ref_number":"MC-4f0f7ffe36416b71cfd1","description":"a package","weight":10.0,"height":12.0,"depth":10.0,"width":10.0,"value":100.0,"shipping_cost":1173.06,"status":0,"agency_id":1,"date_added":"2014-10-16T01:53:51.040Z","date_arrived":null,"date_delivered":null,"sender_id":1,"receiver_id":2,"created_at":"2014-10-16T01:53:51.047Z","updated_at":"2014-10-16T01:53:51.047Z"} '
			def create

				package = Package.new

				package.receiver_id = params[:receiver_id]
				package.sender_id = params[:sender_id]
				package.agency_id = params[:agency_id]
				package.description = params[:description]
				package.value = params[:value]
				package.width = params[:width]
				package.depth = params[:depth]
				package.height = params[:height]
				package.weight = params[:weight]

				shipping_cost = get_shipping_cost(params[:height],params[:weight],params[:depth],params[:width],params[:value])

				package.shipping_cost = shipping_cost
				package.ref_number = generate_ref_number
				package.date_added = Time.now

				if package.save
					render status: :ok, json: package
				else
					render status: :ok, json: package.errors
				end
			end

			api :PUT, "/package/:id", "Update package status and dates"
			formats ['json']
			param :id, :number, desc: 'Package database ID', required: :true
			param :status, ["0", "1", "2"], desc: 'Package status', required: :true
			example ' {"id":10,"ref_number":"MC-4f0f7ffe36416b71cfd1","description":"a package","weight":10.0,"height":12.0,"depth":10.0,"width":10.0,"value":100.0,"shipping_cost":1173.06,"status":1,"agency_id":1,"date_added":"2014-10-16T01:53:51.000Z","date_arrived":"2014-10-16T01:57:38.955Z","date_delivered":null,"sender_id":1,"receiver_id":2,"created_at":"2014-10-16T01:53:51.000Z","updated_at":"2014-10-16T01:57:38.962Z"} '
			def update

				package = Package.find_by_id(params[:id])

				if package.blank?
					render status: :bad_request
				else
					package.status = params[:status]

					if params[:status] == '1'
						package.date_arrived = Time.now
					end
					if params[:status] == '2'
						package.date_delivered = Time.now
					end
						
					if package.save
						render status: :ok, json: package.to_json
					else
						render status: :bad_request, json: package.errors				
					end
				end
			end

		end
	end
end
