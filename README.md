# FirebaseFaradayClient

[![Build Status](https://travis-ci.com/leanhdaovn/firebase_faraday_client.svg?branch=master)](https://travis-ci.com/leanhdaovn/firebase_faraday_client)

[firebase](https://github.com/oscardelben/firebase-ruby/) is a great simplistic gem to interact with firebase via the REST APIs. It uses [httpclient](https://github.com/nahi/httpclient) under the hood to handle the requests. However, `httpclient` hasn't been maintained for a while. Also, in some scenario, you might want to use another client.

`firebase_faraday_client` replaces it with `faraday`, so you can switch to the client of your choice easily.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'firebase_faraday_client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install firebase_faraday_client

## Usage

Enable during startup
```ruby
# config/initializers/firebase.rb

FirebaseFaradayClient.use
```

Use another faraday adapter
```ruby
client = Firebase::Client.new('https://test.firebaseio.com/', nil) do |faraday_connection|
  faraday_connection.options.timeout = 5
  faraday_connection.options.open_timeout = 2
  faraday_connection.adapter :net_http_persistent, pool_size: 10
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/firebase_faraday_client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the FirebaseFaradayClient project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/firebase_faraday_client/blob/master/CODE_OF_CONDUCT.md).
