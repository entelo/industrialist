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
class Cabriolet; end

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
      Cabriolet
    end
  end
end

AutomobileFactory.build(:sedan)
```

Another way to do this is with a hash:

```ruby
class Sedan; end
class Coupe; end
class Cabriolet; end

class AutomobileFactory
  AUTOMOBILE_KLASSES = {
    sedan: Sedan,
    coupe: Coupe,
    convertible: Cabriolet
  }.freeze

  def self.build(automobile_type)
    AUTOMOBILE_KLASSES[automobile_type]&.new
  end
end

AutomobileFactory.build(:coupe)
```

But, both of these approaches require you to maintain your factory by hand. In order to extend these factories, you must modify them, which violates the Open/Closed Principle.

The Ruby way to do this is with conventions and metaprogramming:

```ruby
class AutomobileFactory
  def self.build(automobile_type, *args)
    Object.get_const("#{automobile_type.capitalize}").new(*args)
  end
end
```

But, factories of this type also have issues. If your keys are not easily mapped to a convention, you won't be able to use this type of factory. For example, the `Cabriolet` class above corresponds to the key `:convertible`.

You can find a deeper dive into the motivations behind Industrialst [here](https://engineering.entelo.com/extension-without-modification-cb0f9cfb64a3).

## Usage

Industrialist creates factories for you. Just include the Manufacturable module in a base class and call `create_factory` with a name. Industrialist also allows children of the base class to register themselves with the factory by specifying their corresponding key.

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

AutomobileFactory.build(:sedan)  # => #<Sedan:0x00007ff64d88ce58>
```

Manufacturable classes may also correspond to multiple keys:

```ruby
class Cabriolet < Automobile
  corresponds_to :cabriolet
  corresponds_to :convertible
end
```

By default, Industrialist factories will return `nil` when built with an unregistered key. If you would instead prefer a default object, you can designate a `manufacturable_default`.

```ruby
class Airplane
  include Industrialist::Manufacturable
  create_factory :AirplaneFactory
end

class Biplane < Airplane
  manufacturable_default
  corresponds_to :biplane
end

class FighterJet < Airplane
  corresponds_to :fighter
end

AirplaneFactory.build(:plane)  # => #<Biplane:0x00007ffcd4165610>
```

Finally, Industrialist will accept any Ruby object as a key, which is handy when you need to define more complex keys. For example, you could use a hash:

```ruby
class Train
  include Industrialist::Manufacturable
  create_factory :TrainFactory
end

class SteamEngine < Train
  corresponds_to engine: :steam
end

class Diesel < Train
  corresponds_to engine: :diesel
end

class Boxcar < Train
  corresponds_to cargo: :boxcar
end

class Carriage < Train
  corresponds_to passenger: :carriage
end

class Sleeper < Train
  corresponds_to passenger: :sleeper
end

def train_car(role, type)
  TrainFactory.build(role => type)
end

train_car(:engine, :diesel)  # => #<Diesel:0x00007ff64f846640>
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

If you are using Industrialist with Rails, you'll need to preload your manufacturable objects in the development and test environments in an intializer, like this:

```ruby
def require_factory(class_type)
  Dir[Rails.root.join('app', "#{class_type}", '**', '*.rb').to_s].each { |file| require file }
end

if %w(development test).include?(Rails.env)
  require_factory('airplanes')
  require_factory('trains')
  require_factory('automobiles')
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/entelo/industrialist.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Industrialist project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/industrialist/blob/master/CODE_OF_CONDUCT.md).
