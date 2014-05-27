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

a = Netforum.authenticate('blueskyxweb', 'jx3zXy3C')
o = Netforum.on_demand(a.authentication_token)
# o.get_customer_by_key('61d2e6df-a03c-4887-89d7-24eae05488b6')

# o.get_customer_event('61d2e6df-a03c-4887-89d7-24eae05488b6')
# o.get_customer_event('ec8f7ac3-4a05-416d-9cf0-c447d4348c54')
end
