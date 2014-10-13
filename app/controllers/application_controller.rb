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

end
