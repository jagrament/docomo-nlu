# DocomoNlu

DocomoNlu is a HTTP Client library that provides simple way to access to  NLPManagementAPI of docomo NLU.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'docomo-nlu'
```

And then execute: `bundle install`

## Getting Started

You can use generator command to setup.

```
  $ bundle exec rails generate docomo-nlu:install
```

The generator command will install an initializer  to `config/initializer/docomo-nlu.rb`, which all docomo-nlu options.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jagrament/docomo-nlu. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the DocomoNlu project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/jagrament/docomo-nlu/blob/master/CODE_OF_CONDUCT.md).
