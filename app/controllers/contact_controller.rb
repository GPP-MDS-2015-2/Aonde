require 'rest-client'
# Comunicate with API to send a email
class ContactController < ApplicationController
  def send_simple_message
    user_email = params[:from]
    subject = params[:subject]
    text = params[:text]
    if !user_email.empty? && !subject.empty? && !text.empty?
      mailgun_api = Rails.application.secrets.secret_mailgun_api
      RestClient.post 'https://api:' + mailgun_api +
        '@api.mailgun.net/v3/aondebrasil.com/messages',
                      from: user_email,
                      to: 'contato@aondebrasil.com',
                      subject: subject,
                      text: text
      redirect_to root_path
    else
      fail 'Campos vazios'
    end
  end
end
