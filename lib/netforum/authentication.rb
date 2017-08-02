require 'savon'
require 'httpclient'

module Netforum
  class Authentication
    attr_reader :last_request, :last_response

    def initialize(username, password)
      @auth_token = nil
      @username = username
      @password = password
    end

    def authenticate
      begin
        operation = client.operation(:authenticate)
        response = operation.call(message: { 'userName' => @username, 'password' => @password })
        @last_request = operation.raw_request
        @last_response = operation.raw_response
        @auth_token = response.body[:authenticate_response][:authenticate_result]
        true
      rescue Savon::SOAPFault => e
        @last_request ||= operation.raw_request
        @last_response = e.http
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
      begin
        authenticate unless authenticated?
        operation = client.operation(:get_cst_key_from_sign_on_token)
        response = operation.call(message: { 'AuthToken' => authentication_token, 'szEncryptedSingOnToken' => sign_on_token })
        @last_request = operation.raw_request
        @last_response = operation.raw_response
        if response.success?
          response.body[:get_cst_key_from_sign_on_token_response][:get_cst_key_from_sign_on_token_result]
        end
      rescue Savon::SOAPFault => e
        @last_request ||= operation.raw_request
        @last_response = e.http
        nil
      end
    end

    def get_sign_on_token(username, password, expires_in=60)
      begin
        authenticate unless authenticated?
        operation = client.operation(:get_sign_on_token)
        response = operation.call(message: { 'Email' => username, 'Password' => password, 'AuthToken' => authentication_token, 'Minutes' => expires_in })
        @last_request = operation.raw_request
        @last_response = operation.raw_response
        response.body[:get_sign_on_token_response][:get_sign_on_token_result].gsub('ssoToken=', '')
      rescue Savon::SOAPFault => e
        @last_request ||= operation.raw_request
        @last_response = e.http
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
