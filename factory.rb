class Factory

  def self.new(*attributes, &block)
    Class.new do
      self.send(:attr_accessor, *attributes)
      self.send(:define_method, :initialize) do |*values|
        values.each_with_index { |val, i| self.send("#{attributes[i]}=", val) }
      end

      define_method :[] do |attribute|
        attribute.is_a?(Numeric) ? send("#{attributes[attribute]}") : send(attribute)
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
