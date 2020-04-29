module Netforum
  class OnDemand
    attr_reader :authentication_token, :last_request, :last_response
    attr_accessor :read_timeout, :open_timeout

    def initialize(authentication_token)
      @authentication_token = authentication_token
      @read_timeout = nil
      @open_timeout = nil
    end

    def get_active_product_list(date_since=nil)
      get_array('get_active_product_list', {szRecordDate: date_since}, Product)
    end

    def get_active_product_list_by_individual(customer_id, date_since=nil)
      get_array('get_active_product_list_by_individual', {cstid: customer_id, szRecordDate: date_since}, Product)
    end

    def get_customer_event(customer_key, date_since=nil)
      get_array('get_customer_event', {szCstKey: customer_key, szRecordDate: date_since}, CustomerEvent)
    end

    def get_customer_by_key(customer_key)
      get_object('get_customer_by_key', {szCstKey: customer_key}, User)
    end

    def get_event_by_key(event_key)
      get_object('get_event_by_key', {szKey: event_key}, Event, output_name: 'get_event_list_by_key')
    end

    def get_event_by_product_key(product_key)
      get_object('get_event_by_product_key', {szKey: product_key}, Event)
    end

    def get_event_fees_by_event_key(event_key, options={})
      default_params = {szEventkey: event_key, szSessionKey: nil, szAvailableAsOfDate: nil, bOnlineOnly: 'false',  bExcludeInactive: 'false'}
      get_array('get_event_fees_by_event_key', default_params.merge(options), EventFee)
    end

    def get_prices_by_product_key(product_key)
      get_array('get_prices_by_product_key', {prdkey: product_key}, Price)
    end

    def get_registrants_by_key(event_key, options={})
       default_params = {eventkey: event_key, firstname: nil, lastname: nil, orgname: nil, regid:nil}
       get_array('get_registrants_by_key', default_params.merge(options), Registrant)
    end

    private

    def client
      return @client if defined?(@client)

      options[:read_timeout] = read_timeout if read_timeout.present?
      options[:open_timeout] = open_timeout if open_timeout.present?

      @client = Savon.client(options) do |globals|
        globals.wsdl Configuration.on_demand_wsdl

        # override endpoint address so http schemes match what is in WSDL
        globals.endpoint Configuration.on_demand_wsdl.gsub('?WSDL', '')
      end
    end

    def get_array(service, params, klass, options={})
      operation = client.operation(service.to_sym)
      response = operation.call(message: params, soap_header: {'tns:AuthorizationToken' => {'tns:Token' => authentication_token}})
      @last_request = operation.raw_request
      @last_response = operation.raw_response
      set_auth_token(response)

      return_list = []
      output_name = options[:output_name] || service

      if response.success? && response.body["#{output_name}_response".to_sym]["#{output_name}_result".to_sym]
        results = response.body["#{output_name}_response".to_sym]["#{output_name}_result".to_sym][:results][:result] || []
        unless results.is_a?(Array)
          results = [results]
        end

        results.each do |result|
          return_list << klass.new(result)
        end
      end

      return_list
    rescue Savon::SOAPFault => e
      @last_request ||= operation.raw_request
      @last_response = e.http
      []
    end

    def get_object(service, params, klass, options={})
      operation = client.operation(service.to_sym)
      response = operation.call(message: params, soap_header: {'tns:AuthorizationToken' => {'tns:Token' => authentication_token}})
      @last_request = operation.raw_request
      @last_response = operation.raw_response
      set_auth_token(response)

      output_name = options[:output_name] || service

      if response.success? && response.body["#{output_name}_response".to_sym]["#{output_name}_result".to_sym]
        klass.new(response.body["#{output_name}_response".to_sym]["#{output_name}_result".to_sym][:results][:result])
      else
        nil
      end
    rescue Savon::SOAPFault => e
      @last_request ||= operation.raw_request
      @last_response = e.http
      nil
    end

    def set_auth_token(response)
      @authentication_token = response.header[:authorization_token][:token]
    end
  end
end
