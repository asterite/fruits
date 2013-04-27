class Monster < Chingu::GameObject
  include Chingu::Helpers::GFX

  MaxEnergy = 100
  MaxPatience = 100

  EnergyColor = Gosu::Color.argb(0xFF008800)
  PatienceColor = Gosu::Color.argb(0xFF0000FF)

  trait :timer
  attr_reader :lane

  def setup
    @kind = options[:kind].new(self)
    @energy = options[:energy] || 100
    @patience = options[:patience] || 100
    self.lane = options[:lane]
    self.y = 420
    self.zorder = 30
    @now = Time.now
    @count = 0

    every(2000) do
      @patience -= 1
    end

    every(1000) do
      @energy -= 1
    end
  end

  def draw
    super
    draw_patience
    draw_energy
  end

  def draw_patience
    draw_status @patience, MaxPatience, PatienceColor, 8
  end

  def draw_energy
    draw_status @energy, MaxEnergy, EnergyColor, 16
  end

  def draw_status(value, reference, color, offset)
    status_width = value * (width - 4) / reference
    fill_rect Chingu::Rect.new(x - (width - 4) / 2, y + offset, width - 4, 8), Gosu::Color::BLACK, 30
    fill_rect Chingu::Rect.new(x - (width - 4) / 2, y + offset, status_width, 8), color, 30
    draw_rect Chingu::Rect.new(x - (width - 4) / 2, y + offset, width - 4, 8), Gosu::Color::WHITE, 30
  end

  def lane=(lane)
    @lane = lane
    self.x = 160 + 80 * lane
  end

  def eat(fruit)
    @energy += fruit.energy
    fruit.destroy
  end
end

class SweetTooth
  def initialize(monster)
    @monster = monster
    @monster.image = Image["sweet_tooth.png"]
  end
end