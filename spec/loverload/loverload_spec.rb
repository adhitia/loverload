require 'loverload'

describe Loverload do
  it "makes your code more magical" do
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
    dummy.hello.should eql 'Hello Nobody'
    dummy.hello('Teja').should eql 'Hello Teja'
    dummy.hello('Teja', 21).should eql 'Hello Teja Age 21'
  end

  it "makes your code even more magical" do
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
    dummy.hello('Teja').should     eql 'Hello Name: Teja'
    dummy.hello(21).should         eql 'Hello Age: 21'
    dummy.hello('Teja', 21).should eql 'Hello Name: Teja Age: 21'
    dummy.hello(21, 'Teja').should eql 'Hello Age: 21 Name: Teja'
  end

  it "makes you puke rainbow" do
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
    dummy.before_save(Dummy.new).should            eql "Puke rainbow"
    dummy.before_save(:symbol).should              eql "Puke more rainbow"
    dummy.before_save(proc{|this| is proc}).should eql "Puke rainbow and leprechaun"
    dummy.before_save('string').should             eql "Puke rainbow, leprechaun, and gold"
  end

  it "can call another method" do
    class Dummy
      include Loverload

      def another_method
        'Hello from another method'
      end

      def_overload :call_another_method do
        with_params do
          another_method
        end
      end
    end

    dummy = Dummy.new

    dummy.call_another_method.should eql 'Hello from another method'
  end

  it "shared state" do
    class Dummy
      include Loverload

      def initialize
        @hello = 'World'
      end

      def another_method
        'Hello from another method'
      end

      def_overload :call_another_method do
        with_params do
          "#@hello, #{ another_method }"
        end
      end
    end

    dummy = Dummy.new

    dummy.call_another_method.should eql 'World, Hello from another method'
  end

  it "can have two overload methods" do
    class Dummy
      include Loverload

      def another_method
        'Hello from another method'
      end

      def_overload :method_1 do
        with_params do
          'method_1'
        end

        with_params do |arg|
          "method_1 with arg"
        end
      end

      def_overload :method_2 do
        with_params do
          'method_2'
        end

        with_params do |arg|
          "method_2 with arg"
        end
      end
    end

    dummy = Dummy.new
    dummy.method_1.should eql 'method_1'
    dummy.method_1(1).should eql 'method_1 with arg'
    dummy.method_2.should eql 'method_2'
    dummy.method_2(1).should eql 'method_2 with arg'
  end
end
