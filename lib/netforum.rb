require "netforum/version"
require "netforum/configuration"
require "netforum/authentication"
require "netforum/on_demand"
require "netforum/user"
require "netforum/product"
require "netforum/customer_event"
require "netforum/event"
require "netforum/event_fee"
require "netforum/price"
require "netforum/registrant"

module Netforum

  def self.configure(&block)
    Configuration.class_eval(&block)
  end

  def self.authenticate(username, password)
    auth = Authentication.new(username, password)
    if auth.authenticate
      auth
    else
      nil
    end
  end

  def self.on_demand(authentication_token)
    OnDemand.new(authentication_token)
  end
end
