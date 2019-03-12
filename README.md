[![Gem Version](https://badge.fury.io/rb/industrialist.svg)](https://badge.fury.io/rb/industrialist)
[![Maintainability](https://api.codeclimate.com/v1/badges/96f6341cfb748a19f90c/maintainability)](https://codeclimate.com/github/entelo/industrialist/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/96f6341cfb748a19f90c/test_coverage)](https://codeclimate.com/github/entelo/industrialist/test_coverage)
[![CircleCI](https://circleci.com/gh/entelo/industrialist.svg?style=svg)](https://circleci.com/gh/entelo/industrialist)

# Industrialist

Industrialist manufactures factories that build self-registered classes.

## Background

At the heart of your typical Gang of Four factory method is a case statement:

```ruby
class Sedan; end
class Coupe; end
class Convertible; end

class AutomobileFactory
  def self.build(automobile_type)
    automobile_klass(automobile_type)&.new
  end

  def self.automobile_klass(automobile_type)
    case automobile_type
    when :sedan
      Sedan
    when :coupe
      Coupe
    when :convertible
      Convertible
    end
  end
end

AutomobileFactory.build(:sedan)
```

The Ruby way to do this is with a Hash:

```ruby
class Sedan; end
class Coupe; end
class Convertible; end

class AutomobileFactory
  AUTOMOBILE_KLASSES = {
    sedan: Sedan,
    coupe: Coupe,
    convertible: Convertible
  }.freeze

  def self.build(automobile_type)
    AUTOMOBILE_KLASSES[automobile_type]&.new
  end
end

AutomobileFactory.build(:coupe)
```

But, both of these approaches require you to maintain your factory by hand. In order to extend these factories, you must modify them, which violates the Open/Closed Principle.

## Usage

Industrialist creates factories for you. Just include the Manufacturable module in a base class and give the factory a name. Industrialist also allows children of the base class to register themselves with the factory by specifying their corresponding key. Like this:

```ruby
class Automobile
  include Industrialist::Manufacturable
  create_factory :AutomobileFactory
end

class Sedan < Automobile
  corresponds_to :sedan
end

class Coupe < Automobile
  corresponds_to :coupe
end

class Cabriolet < Automobile
  corresponds_to :convertible
end

AutomobileFactory.build(:convertible)
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'industrialist'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install industrialist

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/entelo/industrialist. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Industrialist project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/industrialist/blob/master/CODE_OF_CONDUCT.md).
