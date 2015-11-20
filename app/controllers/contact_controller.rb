require 'rest-client'
#Comunicate with API to send a email
class ContactController < ApplicationController
	def send_simple_message
		user_email = params[:from]
		subject = params[:subject]
		text = params[:text]
		mailgun_api = Rails.application.secrets.secret_mailgun_api
		puts "\n\n\n\n\n\n\n\n\n\n#{mailgun_api}\n\n\n\n\n"
		puts "="*80
  		RestClient.post "https://api:" + mailgun_api +
  			"@api.mailgun.net/v3/sandboxbbc37158ab4041f3881034b2576a4d64.mailgun.org/messages",
	  		:from => user_email,
	  	  	:to => "contato@aondebrasil.com",
	  	  	:subject => subject,
	  	  	:text => text

	  	redirect_to root_path
	end
end