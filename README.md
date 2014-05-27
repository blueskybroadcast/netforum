# Netforum

Ruby gem to interact with Avectra's Netforum Pro API.

## Installation

Add this line to your application's Gemfile:

    gem 'netforum'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install netforum

## Usage

To authenticate with the API and get an auth token:

    if auth = Netforum.authenticate('api_username', 'api_password')
      # credentials are valid, go forth and prosper
      token = auth.authentication_token
    else
      # invalid credentials
    end

Get a customer key:

    auth = Netforum.authenticate('api_username', 'api_password')
    token = auth.get_sign_on_token('user', 'password')
    key = auth.get_customer_key(token)

Get a customer by key via the On Demand API:

    auth = Netforum.authenticate('api_username', 'api_password')
    on_demand = Netforum::OnDemand(auth.authentication_token)
    customer = on_demand.get_customer_by_key(key)


## Contributing

1. Fork it ( http://github.com/<my-github-username>/netforum/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
