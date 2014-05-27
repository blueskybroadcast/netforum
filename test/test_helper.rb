require 'netforum'
require 'minitest/autorun'
require 'minitest/pride'
require 'webmock/minitest'
require 'byebug'

def stub_authentication_wsdl
  stub_request(:get, "https://uat.netforumpro.com/xWeb/Signon.asmx?WSDL").
    to_return(:status => 200, :body => File.read('test/fixtures/sign_on_wsdl.xml'), :headers => {})
end

def stub_authenticate_success
  stub_request(:post, "https://uat.netforumpro.com/xWeb/Signon.asmx").
    with(:headers => {'Soapaction'=>'"http://tempuri.org/Authenticate"'}).
    to_return(:status => 200, :body => File.read('test/fixtures/authenticate_success.xml'), :headers => {})
end

def stub_authenticate_failure
  stub_request(:post, "https://uat.netforumpro.com/xWeb/Signon.asmx").
    with(:headers => {'Soapaction'=>'"http://tempuri.org/Authenticate"'}).
    to_return(:status => 500, :body => File.read('test/fixtures/authenticate_failure.xml'), :headers => {})
end

def stub_get_sign_on_token_success
  stub_request(:post, "https://uat.netforumpro.com/xWeb/Signon.asmx").
    with(:headers => {'Soapaction'=>'"http://tempuri.org/GetSignOnToken"'}).
    to_return(:status => 200, :body => File.read('test/fixtures/get_sign_on_token_success.xml'), :headers => {})
end

def stub_get_sign_on_token_invalid_credentials
  stub_request(:post, "https://uat.netforumpro.com/xWeb/Signon.asmx").
    with(:headers => {'Soapaction'=>'"http://tempuri.org/GetSignOnToken"'}).
    to_return(:status => 200, :body => File.read('test/fixtures/get_sign_on_token_invalid_credentials.xml'), :headers => {})
end

def stub_get_customer_key_success
  stub_request(:post, "https://uat.netforumpro.com/xWeb/Signon.asmx").
    with(:headers => {'Soapaction'=>'"http://tempuri.org/GetCstKeyFromSignOnToken"'}).
    to_return(:status => 200, :body => File.read('test/fixtures/get_customer_key_success.xml'), :headers => {})
end

def stub_get_customer_key_failure
  stub_request(:post, "https://uat.netforumpro.com/xWeb/Signon.asmx").
    with(:headers => {'Soapaction'=>'"http://tempuri.org/GetCstKeyFromSignOnToken"'}).
    to_return(:status => 200, :body => File.read('test/fixtures/get_customer_key_failure.xml'), :headers => {})
end

def stub_on_demand_wsdl
  stub_request(:get, "https://uat.netforumpro.com/xweb/netFORUMXMLONDemand.asmx?WSDL").
    to_return(:status => 200, :body => File.read('test/fixtures/on_demand_wsdl.xml'), :headers => {})
end

def stub_get_customer_by_key_success
  stub_request(:post, "https://uat.netforumpro.com/xweb/netFORUMXMLONDemand.asmx").
    with(:headers => {'Soapaction'=>'"http://www.avectra.com/OnDemand/2005/GetCustomerByKey"'}).
    to_return(:status => 200, :body => File.read('test/fixtures/get_customer_by_key_success.xml'), :headers => {})
end

def stub_get_customer_by_key_failure
  stub_request(:post, "https://uat.netforumpro.com/xweb/netFORUMXMLONDemand.asmx").
    with(:headers => {'Soapaction'=>'"http://www.avectra.com/OnDemand/2005/GetCustomerByKey"'}).
    to_return(:status => 200, :body => File.read('test/fixtures/get_customer_by_key_no_results.xml'), :headers => {})
end

def stub_get_active_product_list_by_individual_success(number_of_products=1)
  stub_request(:post, "https://uat.netforumpro.com/xweb/netFORUMXMLONDemand.asmx").
    with(:headers => {'Soapaction'=>'"http://www.avectra.com/OnDemand/2005/GetActiveProductListByIndividual"'}).
    to_return(:status => 200, :body => File.read('test/fixtures/get_active_product_list_by_individual_success' + number_of_products.to_s + '.xml'), :headers => {})
end

def stub_get_customer_event_success(number_of_events=1)
  stub_request(:post, "https://uat.netforumpro.com/xweb/netFORUMXMLONDemand.asmx").
    with(:headers => {'Soapaction'=>'"http://www.avectra.com/OnDemand/2005/GetCustomerEvent"'}).
    to_return(:status => 200, :body => File.read('test/fixtures/get_customer_event_success' + number_of_events.to_s + '.xml'), :headers => {})
end
