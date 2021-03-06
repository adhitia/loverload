# Loverload

DSL for building method overloading in Ruby.

Rigid language like Java allow you to create method overloading:

``` java
public void draw(String s) {
    ...
}
public void draw(int i) {
    ...
}
public void draw(double f) {
    ...
}
public void draw(int i, double f) {
    ...
}
```

However, in Ruby, we don't have this kind of thing, _do we_?

``` ruby
before_save NameSayer.new
before_save :say_my_name
before_save {|record| puts "My name is #{record.name}" }
before_save 'puts "My name is #{self.name}"'
```

[An Intervention for ActiveRecord](https://speakerdeck.com/erniemiller/an-intervention-for-activerecord) by [Ernie Miller](http://erniemiller.org)


## Installation

Add this line to your application's Gemfile:

    gem 'loverload'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install loverload

## Usage

Simple

``` ruby
class Dummy
  include Loverload

  def_overload :hello do
    with_params do
      "Hello Nobody"
    end

    with_params do |name|
      "Hello #{ name }"
    end

    with_params do |name, age|
      "Hello #{ name } Age #{ age }"
    end
  end
end

dummy = Dummy.new
dummy.hello #=> 'Hello Nobody'
dummy.hello('Teja') #=> 'Hello Teja'
dummy.hello('Teja', 21) #=> 'Hello Teja Age 21'
```

Strict
``` ruby
class Dummy
  include Loverload

  def_overload :hello do
    with_params String do |name|
      "Hello Name: #{ name }"
    end

    with_params Fixnum do |age|
      "Hello Age: #{ age }"
    end

    with_params String, Fixnum do |name, age|
      "Hello Name: #{ name } Age: #{ age }"
    end

    with_params Fixnum, String do |age, name|
      "Hello Age: #{ age } Name: #{ name }"
    end
  end
end

dummy = Dummy.new
dummy.hello('Teja') #=> 'Hello Name: Teja'
dummy.hello(21) #=> 'Hello Age: 21'
dummy.hello('Teja', 21) #=> 'Hello Name: Teja Age: 21'
dummy.hello(21, 'Teja') #=> 'Hello Age: 21 Name: Teja'
dummy.hello('Teja', 21, true) #=> NoMethodError
```

This is how you do :before_save
``` ruby
class Dummy
  include Loverload

  def_overload :before_save do
    with_params Dummy do |dummy|
      "Puke rainbow"
    end

    with_params Symbol do |symbol|
      "Puke more rainbow"
    end

    with_params Proc do |proc|
      "Puke rainbow and leprechaun"
    end

    with_params String do |string|
      "Puke rainbow, leprechaun, and gold"
    end
  end
end

dummy = Dummy.new
dummy.before_save(Dummy.new) #=> "Puke rainbow"
dummy.before_save(:symbol) #=> "Puke more rainbow"
dummy.before_save(proc{|this| is proc}) #=> "Puke rainbow and leprechaun"
dummy.before_save('string') #=> "Puke rainbow, leprechaun, and gold"
```

## TODO
- Make it less ugly

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
