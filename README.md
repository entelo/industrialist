[![Gem Version](https://badge.fury.io/rb/industrialist.svg)](https://badge.fury.io/rb/industrialist)
[![Maintainability](https://api.codeclimate.com/v1/badges/96f6341cfb748a19f90c/maintainability)](https://codeclimate.com/github/entelo/industrialist/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/96f6341cfb748a19f90c/test_coverage)](https://codeclimate.com/github/entelo/industrialist/test_coverage)
[![CircleCI](https://circleci.com/gh/entelo/industrialist.svg?style=svg)](https://circleci.com/gh/entelo/industrialist)

# Industrialist

Industrialist makes your factory code easy to extend and resilient to change.

It was inspired by the Gang-of-Four [factory method](https://en.wikipedia.org/wiki/Factory_method_pattern) and [abstract factory](https://en.wikipedia.org/wiki/Abstract_factory_pattern) patterns.

Factory code often involves a case statement. If you are switching on a key in order to choose which class to build, you have a factory:

```ruby
def automobile(automobile_type)
  case automobile_type
  when :sedan
    Sedan.new
  when :coupe
    Coupe.new
  when :convertible
    Cabriolet.new
  end
end
```

This code often lives inside a class with other responsibilities. By applying the [Single Responsibility Principle](https://en.wikipedia.org/wiki/Single_responsibility_principle), you can extract it into a factory class:

```ruby
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

AutomobileFactory.build(:sedan)  # => #<Sedan:0x00007ff64d88ce58>
```

Another way to do this is with a hash:

```ruby
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

AutomobileFactory.build(:coupe)  # => #<Coupe:0x00007ff64b6a372>
```

But, both of these approaches require you to maintain your factory by hand. In order to extend these factories, you must modify them, which violates the [Open/Closed Principle](https://en.wikipedia.org/wiki/Open%E2%80%93closed_principle).

The Ruby way to do this is with conventions and metaprogramming:

```ruby
class AutomobileFactory
  def self.build(automobile_type, *args)
    Object.get_const("#{automobile_type.capitalize}").new(*args)
  end
end
```

But, factories of this type also have issues. If your convention changes, you'll have to edit the factory, which violates teh Open/Closed principle. Or, if your keys are not easily mapped to a convention, you won't be able to use this type of factory. For example, the `Cabriolet` class above corresponds to the key `:convertible`. 

You can find a deeper dive into the motivations behind Industrialst [here](https://engineering.entelo.com/extension-without-modification-cb0f9cfb64a3).

## Usage

Industrialist manages a factory of factories, so you don't have to. Setting it up is easy. When you create a factory class, extend `Industrialist::Factory`, and tell Industrialist the base class of the classes your factory will manufacture:

```ruby
class AutomobileFactory
  extend Industrialist::Factory
  manufactures Automobile
end
```

Next, tell Industrialist that the base class is manufacturable by extending `Industrialist::Manufacturable`:

```ruby
class Automobile
  extend Industrialist::Manufacturable
end
```

And, finally, tell each of your subclasses what key to register themselves under:

```ruby
class Sedan < Automobile
  corresponds_to :sedan
end

class Coupe < Automobile
  corresponds_to :coupe
end
```

As the subclasses are loaded by Ruby, they register themselves with the appropriate factory so that you can do this:

```ruby
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
class PlaneFactory
  extend Industrialist::Factory
  manufactures Plane
end

class Plane
  extend Industrialist::Manufacturable
end

class Biplane < Plane
  manufacturable_default
  corresponds_to :biplane
end

class FighterJet < Plane
  corresponds_to :fighter
end

PlaneFactory.build(:bomber)  # => #<Biplane:0x00007ffcd4165610>
```

Industrialist can accept any Ruby object as a key, which is handy when you need to define more complex keys. For example, you could use a hash:

```ruby
class TrainFactory
  extend Industrialist::Factory
  manufactures Train
end

class Train
  extend Industrialist::Manufacturable
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

TrainFactory.build(engine: :diesel)  # => #<Diesel:0x00007ff64f846640>
```

For convenience, you can choose not to define your own factories. Instead, just use Industrialist directly:

```ruby
Industrialist.build(:plane, :bomber)          # => #<Biplane:0x00007ffcd4165610>
Industrialist.build(:train, engine: :diesel)  # => #<Diesel:0x00007ff64f846640>
Industrialist.build(:autombile, :sedan)       # => #<Sedan:0x00007ff64d88ce58>
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

If you are using Industrialist with Rails, you'll need to

```ruby
Industrialist.config do |config|
  config.manufacturable_paths << Rails.root.join('app', 'planes')
  config.manufacturable_paths << Rails.root.join('app', 'trains')
  config.manufacturable_paths << Rails.root.join('app', 'automobiles')
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/entelo/industrialist.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Industrialist project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/entelo/industrialist/blob/master/CODE_OF_CONDUCT.md).
