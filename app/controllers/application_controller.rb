class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session


    # Generate an unique token
    def generate_token

        # Generate random token untill is unique
        begin
            new_token = SecureRandom.base64(64)
            tokens = Session.all.map{ |t| t.token}
        end while tokens.include? new_token

        return new_token
    end

    # Validate the token is valid and belongs to existing user
    def validate_token

        # Get token active record
        session = Session.where(token: request.headers["token"]).first

        # Check if session exists and have valid user
        if !session.blank? && !session.user.blank?
            return true
        else
            render status: :unauthorized,json: {error_code: "Invalid token", error_description: "Token given doesn't match"}
        end
    end

    def validate_admin
        if current_user.is_admin?
            return true
        else
            render status: :unauthorized,json: {error_code: "Invalid access", error_description: "You can't access this resorce"}
        end
    end

    def validate_operator
        if !current_user.is_member?
            return true
        else
            render status: :unauthorized,json: {error_code: "Invalid access", error_description: "You can't access this resorce"}
        end
    end

    # Get user associated with token
    def current_user
        Session.where(token: request.headers["token"]).first.user
    end

    def get_shipping_cost(height,weight,depth,width,value)
        # Get last system rate added
        rate = Rate.active.first

        # Get params for formula
        packageRate = rate.package.to_f
        costRate    = rate.cost.to_f
        height      = height.to_f
        weight      = weight.to_f
        depth       = depth.to_f
        width       = width.to_f
        value       = value.to_f

        # calculate final cost
        shipping_cost = ((height*weight*depth*width)/packageRate) + (costRate*(value/100.0)) 

        # Round final cost
        shipping_cost = shipping_cost.round(2)

        return shipping_cost
    end

end
