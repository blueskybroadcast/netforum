require 'test_helper'

class OnDemandTest < MiniTest::Test
  def setup
    stub_on_demand_wsdl
  end

  def test_get_customer_key_success
    stub_get_customer_by_key_success

    service = Netforum::OnDemand.new('123')
    customer = service.get_customer_by_key('key')

    assert_kind_of Netforum::User, customer
  end

  def test_get_customer_key_failure
    stub_get_customer_by_key_failure

    service = Netforum::OnDemand.new('123')
    customer = service.get_customer_by_key('key')

    assert_equal nil, customer
  end

  def test_get_active_product_list_by_individual_success
    stub_get_active_product_list_by_individual_success

    service = Netforum::OnDemand.new('123')
    products = service.get_active_product_list_by_individual('456')

    refute_empty products
  end

  def test_get_active_product_list_by_individual_success_multiple
    stub_get_active_product_list_by_individual_success(2)

    service = Netforum::OnDemand.new('123')
    products = service.get_active_product_list_by_individual('456')

    assert_equal 2, products.size
  end

  def test_get_active_product_list_by_individual_no_results
    stub_get_active_product_list_by_individual_success(0)

    service = Netforum::OnDemand.new('123')
    products = service.get_active_product_list_by_individual('456')

    assert_empty products
  end

  def test_get_customer_event_no_results
    stub_get_customer_event_success(0)

    service = Netforum::OnDemand.new('123')
    events = service.get_customer_event('456')

    assert_empty events
  end

  def test_get_customer_event_success
    stub_get_customer_event_success(1)

    service = Netforum::OnDemand.new('123')
    events = service.get_customer_event('456')

    refute_empty events
  end
end
