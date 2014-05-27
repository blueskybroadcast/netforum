require 'savon'
require 'httpclient'

module Netforum
  class Authentication
    def initialize(username, password)
      @auth_token = nil
      @username = username
      @password = password
    end

    def authenticate
      begin
        response = client.call(:authenticate, message: {'userName' => @username, 'password' => @password})
        @auth_token = response.body[:authenticate_response][:authenticate_result]
        true
      rescue Savon::SOAPFault => e
        @auth_token = nil
        false
      end
    end

    def authenticated?
      !@auth_token.nil?
    end

    def authentication_token
      authenticate unless authenticated?
      @auth_token
    end

    def get_customer_key(sign_on_token)
      authenticate unless authenticated?
      response = client.call(:get_cst_key_from_sign_on_token, message: {'AuthToken' => authentication_token, 'szEncryptedSingOnToken' => sign_on_token})
      if response.success?
        response.body[:get_cst_key_from_sign_on_token_response][:get_cst_key_from_sign_on_token_result]
      end
    end

    def get_sign_on_token(username, password, expires_in=60)
      begin
        authenticate unless authenticated?
        response = client.call(:get_sign_on_token, message: {'Email' => username, 'Password' => password, 'AuthToken' => authentication_token, 'Minutes' => expires_in})
        response.body[:get_sign_on_token_response][:get_sign_on_token_result].gsub('ssoToken=', '')
      rescue Savon::SOAPFault => e
        nil
      end
    end

    private

    def client
      Savon.client(Configuration.client_options) do |globals|
        globals.wsdl Configuration.authentication_wsdl

        # override endpoint address so http schemes match
        globals.endpoint Configuration.authentication_wsdl.gsub('?WSDL', '')
      end
    end
  end
end
