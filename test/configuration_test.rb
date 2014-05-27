require 'test_helper'

class ConfigurationTest < MiniTest::Test
  def setup
    Netforum::Configuration.reset
  end

  def test_authentication_wsdl_returns_default
    wsdl = Netforum::Configuration.authentication_wsdl
    assert_equal 'https://uat.netforumpro.com/xWeb/Signon.asmx?WSDL', wsdl
  end

  def test_authentication_wsdl_can_be_set
    Netforum::Configuration.authentication_wsdl('http://test.com')
    wsdl = Netforum::Configuration.authentication_wsdl

    assert_equal wsdl, 'http://test.com'
  end

  def test_on_demand_wsdl_returns_default
    wsdl = Netforum::Configuration.on_demand_wsdl
    assert_equal 'https://uat.netforumpro.com/xweb/netFORUMXMLONDemand.asmx?WSDL', wsdl
  end

  def test_on_demand_wsdl_can_be_set
    Netforum::Configuration.on_demand_wsdl('http://test.com')
    wsdl = Netforum::Configuration.on_demand_wsdl

    assert_equal wsdl, 'http://test.com'
  end

  def test_client_options_returns_default
    expected_options = {}
    options = Netforum::Configuration.client_options
    assert_equal expected_options, options
  end

  def test_client_options_can_be_set
    expected_options = {log: true}
    Netforum::Configuration.client_options(expected_options)
    options = Netforum::Configuration.client_options
    assert_equal expected_options, options
  end
end
