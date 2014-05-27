require 'test_helper'

class ConfigurationTest < MiniTest::Test
  def setup
    stub_authentication_wsdl
  end

  def test_authenticate_with_valid_credentials
    stub_authenticate_success

    auth = Netforum::Authentication.new('test@test.com', 'testing')
    auth.authenticate

    assert_equal true, auth.authenticated?
  end

  def test_authenticate_with_valid_credentials
    stub_authenticate_failure

    auth = Netforum::Authentication.new('test@test.com', 'testing')
    auth.authenticate

    assert_equal false, auth.authenticated?
  end

  def test_get_sign_on_token_success
    stub_authenticate_success
    stub_get_sign_on_token_success

    auth = Netforum::Authentication.new('test@test.com', 'testing')
    token = auth.get_sign_on_token('user@test.com', 'testing')
    expected_token = '2F4541716E763339546C393564716F44667732674A577A782B7149513651767A6B67466E63707576466265706B38754875536A6B517865643050374B3157662F37757A4F54466B33444C4B77337956774E4D6E5A522B457132735A37364F6B556F537965426E35454354454E4669727373577634476A63524F774D5947656D4F666B47506F50622F5631374E744B56414F4A526C652B75514D38784B5433433365626B4D35336B50665053454D4F5649325250467344547756392F766153383475376E374251383078413663696F45397962463176773D3D'

    assert_equal expected_token, token
  end

  def test_get_sign_on_token_invalid_credentials
    stub_authenticate_success
    stub_get_sign_on_token_invalid_credentials

    auth = Netforum::Authentication.new('test@test.com', 'testing')
    token = auth.get_sign_on_token('user@test.com', 'testing')

    assert_equal nil, token
  end

  def test_get_customer_key_success
    stub_authenticate_success
    stub_get_sign_on_token_success
    stub_get_customer_key_success

    auth = Netforum::Authentication.new('test@test.com', 'testing')
    token = auth.get_sign_on_token('user@test.com', 'testing')
    key = auth.get_customer_key(token)
    expected_key = 'ec8f7ac3-4a05-416d-9cf0-c447d4348c54'

    assert_equal expected_key, key
  end

  def test_get_customer_key_invalid_token
    stub_authenticate_success
    stub_get_sign_on_token_success
    stub_get_customer_key_failure

    auth = Netforum::Authentication.new('test@test.com', 'testing')
    token = auth.get_sign_on_token('user@test.com', 'testing')
    key = auth.get_customer_key(token)

    assert_equal nil, key
  end

end
