# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'nokogiri'
require 'open-uri'
require "image_size"
require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
require 'base64'

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  # protect_from_forgery # See ActionController::RequestForgeryProtection for details

  include AuthenticatedSystem
  include ApplicationHelper
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  def check_login
    unless logged_in?
      flash[:notice] = "Please login."
      redirect_to login_path
    end
  end

  def check_emails(emails)
    return false if emails.blank?
    return false if emails.gsub(',','').blank?
    emails.split(',').each do |email|
        unless email.strip =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/
          return false
        end
    end
    return true
  end

  def base64_url_decode(str)
    str += '=' * (4 - str.length.modulo(4))
    Base64.decode64(str.tr('-_','+/'))
  end

  # Verifies that the signed_request parameter is from Facebook. An
  # exception is thrown if it is not. A hash with the data from the
  # request is returned.
  def parse_signed_request(params, app_secret_key)
    raise Exception.new("No signed request parameter!") unless params.has_key?("signed_request")
    # signed_request is a . delimited string, first part is the signature
    # base64 encoded, second part is the JSON object base64 encoded
    parts = params['signed_request'].split(".")
    json_str = base64_url_decode(parts[1])
    json_obj = JSON.parse(json_str)
    if json_obj['algorithm'] && json_obj['algorithm'] != 'HMAC-SHA256'
      raise Exception.new("Unsupported signature algorithm - #{json_obj['algorithm']}")
    end
    # This is our calculation of the secret key
    expected = OpenSSL::HMAC.digest('sha256',app_secret_key,parts[1])
    actual = base64_url_decode(parts[0])
    if expected != actual
#      raise Exception.new("Validation of request from Facebook failed!")
        return nil
    end
    # This should contain issued_at at a minimum. If this came from a user
    # that has installed your app, it will contain user_id, oauth_token,
    # expires, app_data, page, profile_id
    json_obj
  end
end
