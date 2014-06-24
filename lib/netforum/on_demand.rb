module Netforum
  class OnDemand
    attr_reader :authentication_token

    def initialize(authentication_token)
      @authentication_token = authentication_token
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

    private

    def client
      options = Configuration.client_options.merge(soap_header: {'tns:AuthorizationToken' => {'tns:Token' => authentication_token}})

      Savon.client(options) do |globals|
        globals.wsdl Configuration.on_demand_wsdl

        # override endpoint address so http schemes match what is in WSDL
        globals.endpoint Configuration.on_demand_wsdl.gsub('?WSDL', '')
      end
    end

    def get_array(service, params, klass, options={})
      response = client.call(service.to_sym, message: params)
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
    end

    def get_object(service, params, klass, options={})
      response = client.call(service.to_sym, message: params)
      set_auth_token(response)

      output_name = options[:output_name] || service

      if response.success? && response.body["#{output_name}_response".to_sym]["#{output_name}_result".to_sym]
        klass.new(response.body["#{output_name}_response".to_sym]["#{output_name}_result".to_sym][:results][:result])
      else
        nil
      end
    end

    def set_auth_token(response)
      @authentication_token = response.header[:authorization_token][:token]
    end
  end
end
