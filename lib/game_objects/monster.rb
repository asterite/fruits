# coding: utf-8

class Monster < Chingu::GameObject
  include Chingu::Helpers::GFX

  trait :bounding_box

  MaxEnergy = 100
  MaxPatience = 100

  EnergyColor = Gosu::Color.argb(0xFF008800)
  PatienceColor = Gosu::Color::RED

  traits :timer, :asynchronous
  attr_reader :lane

  def setup
    @kind = options[:kind].new(self)
    @energy = options[:energy] || 100
    @patience = options[:patience] || 100
    @favorite = options[:favorite]
    @favorite_image = @favorite.image if @favorite
    self.lane = options[:lane]
    self.y = 420
    self.zorder = 30
    @now = Time.now
    @count = 0

    every(2000) do
      @patience -= 1
      if @patience == 0
        $window.current_game_state.defeat(self, "A la criatura se le acabó la paciencia")
      end
    end

    every(1000) do
      @energy -= 1
      if @energy == 0
        @kind.no_energy
      end
    end

    cache_bounding_box
  end

  def draw
    super
    unless @leaving
      draw_patience unless hide_patience?
      draw_energy unless hide_energy?

      if @favorite
        @favorite_image.draw self.x - @favorite_image.width / 2, self.y - 70, 2, 1, 1, Gosu::Color.argb(0x44FFFFFF)
      end
    end
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

  def hide_patience
    @hide_patience = true
  end

  def hide_patience?
    @hide_patience
  end

  def hide_energy
    @hide_energy = true
  end

  def hide_energy?
    @hide_energy
  end

  def draw_patience
    draw_status @patience, MaxPatience, PatienceColor, 8
  end

  def draw_energy
    draw_status @energy, MaxEnergy, EnergyColor, 16
  end

  def draw_status(value, reference, color, offset)
    status_width = value * (width - 4) / reference
    fill_rect Chingu::Rect.new(x - (width - 4) / 2, y + offset, width - 4, 8), Gosu::Color::BLACK, zorder
    fill_rect Chingu::Rect.new(x - (width - 4) / 2, y + offset, status_width, 8), color, zorder
    draw_rect Chingu::Rect.new(x - (width - 4) / 2, y + offset, width - 4, 8), Gosu::Color::WHITE, zorder
  end

  def lane=(lane)
    @lane = lane
    self.x = 160 + 80 * lane
  end

  def eat(fruit)
    if @favorite && @favorite != fruit.kind.class
      $window.current_game_state.defeat(self, "La criatura comió una fruta que no es su favorita")
    end

    @energy += fruit.energy
    if @energy >= MaxEnergy
      @energy = MaxEnergy
      @kind.full
    end
    fruit.destroy
  end

  def leave
    return if @leaving
    @leaving = true

    self.angle = 180
    async do |q|
      q.tween 200, y: 640
      q.exec { self.angle = 0 }
      q.tween 200, y: 420
      q.exec do
        @energy = options[:energy] || 100
        @patience = options[:patience] || 100
        @leaving = false
      end
    end
  end
end

class MonsterKind
  attr_reader :image
  attr_reader :blink_image

  def initialize(monster)
    @monster = monster
    @image = self.class.image
    @blink_image = Image["#{self.class.name.downcase}_flash.png"]
    @monster.image = @image
  end

  def self.image
    Image["#{name.downcase}.png"]
  end
end

class SweetTooth < MonsterKind
  def full
    @monster.leave
  end

  def no_energy
    $window.current_game_state.defeat(@monster, "La criatura murió de hambre")
  end
end