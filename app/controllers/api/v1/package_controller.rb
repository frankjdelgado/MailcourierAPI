module Api
	module V1
		class PackageController < ApplicationController

			before_action :validate_token
			before_filter :validate_operator, :only => [:new, :create, :update, :destroy]

			respond_to :json

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

			def show
				package = current_user.packages.find_by_id(params[:id])
				render status: :ok, json: package
			end

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
