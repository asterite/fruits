class Fruit < Chingu::GameObject
  trait :bounding_box
  trait :timer
  attr_reader :lane
  attr_reader :kind

  def setup
    @kind = options[:kind].new(self)
    @speed = options[:speed]
    self.lane = options[:lane]
    self.y = 0
    self.zorder = 10
    cache_bounding_box
  end

  def update
    super
    @y += @speed
  end

  def lane=(lane)
    @lane = lane
    self.x = 160 + 80 * lane
  end

  def energy
    @kind.energy
  end

  def start_blinking
    blinking = true
    self.image = @kind.blink_image
    every(40, name: :blink) do
      blinking = !blinking
      self.image = blinking ? @kind.blink_image : @kind.image
    end
  end

  def stop_blinking
    stop_timer(:blink)
    self.image = @kind.image
  end

  def start_moving
    @speed = options[:speed]
  end

  def stop_moving
    @speed = 0
  end

  def can_be_grabbed?
    @kind.can_be_grabbed?
  end
end

class FruitKind
  attr_accessor :image
  attr_accessor :blink_image

  def initialize(fruit)
    @fruit = fruit
    @image = self.class.image
    @blink_image = Image["#{self.class.name.downcase}_flash.png"]
    @fruit.image = @image
  end

  def self.image
    Image["#{name.downcase}.png"]
  end

  def can_be_grabbed?
    true
  end

  def self.energy(value)
    class_eval %Q(def energy; #{value}; end)
  end
end

class Apple < FruitKind
  energy 15
end

class Banana < FruitKind
  energy 11
end

class Cherry < FruitKind
  energy 2
end

class Lemon < FruitKind
  energy 4
end

class Lime < FruitKind
  energy 4
end

class Orange < FruitKind
  energy 6
end

class Watermelon < FruitKind
  energy 24

  def can_be_grabbed?
    false
  end
end
