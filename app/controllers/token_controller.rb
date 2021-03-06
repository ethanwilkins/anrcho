class TokenController < ApplicationController
  def update
    # is viewing twice upon renew of token in dev
    unless request.bot? or not ENV['RAILS_ENV'].eql? 'development'
      cookies.permanent[:ip] = request.remote_ip.to_s
      cookies.permanent[:token] = SecureRandom.urlsafe_base64
      cookies.permanent[:ip_timestamp] = DateTime.current.to_s
      cookies.permanent[:token_timestamp] = DateTime.current.to_s
      cookies.permanent[:simple_captcha_validated] = ""
      @token = cookies[:token]
      redirect_to root_url
    else
      redirect_to '/404'
    end
  end
  
  def index
    @red = nil
    @green = nil
    @blue = nil
  end
end
