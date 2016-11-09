class Factory

  def self.new(*attributes, &block)
  	@@args = attributes
    Class.new do
      self.send(:attr_accessor, *attributes)
      self.send(:define_method, :initialize) do |*values|
        values.each_with_index { |val, i| self.send("#{attributes[i]}=", val) }
      end 

      def [](index)
          case index
           when Integer 
            send(@@args[index])
           when Symbol, String 
            send("#{index}")
          end
      end

      class_eval(&block) if block_given?

    end
  end
end

Customer = Factory.new(:name, :address, :zip)
joe = Customer.new('Joe Smith', '123 Maple, Anytown NC', 12345)
puts joe.name    # => "Joe Smith"
puts joe['name'] # => "Joe Smith"
puts joe[:name]  # => "Joe Smith"
puts joe[0]      # => "Joe Smith"


Lucker = Factory.new(:name, :address) do
  def greeting
    "Hello #{name}!"
  end
end

puts Lucker.new('Dave', '123 Main').greeting
