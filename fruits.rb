require 'bundler/setup'
require 'chingu'
require 'require_all'

require_all "lib"

include Gosu

class Fruits < Chingu::Window
  def initialize
    super(640, 480, false)

    self.input = { :escape => :exit }

    level = Level.new(1)

    push_game_state Play.new level: level
  end

  def update
    super
    self.caption = "FPS: #{self.fps} milliseconds_since_last_tick: #{self.milliseconds_since_last_tick}"
  end
end

Fruits.new.show