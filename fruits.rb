require 'bundler/setup'
require 'chingu'
require 'require_all'

require_all "lib"

include Gosu

class Fruits < Chingu::Window
  def initialize
    super(640, 480, false)

    self.input = { :escape => :exit }

    if ARGV.length == 0
      level_number = 1
    else
      level_number = ARGV[0].to_i
      level_number = 1 if level_number < 1
    end

    level = Level.new(level_number)

    push_game_state Play.new(level: level)
    push_game_state LevelDescription.new(level: level)
  end

  def update
    super
    self.caption = "FPS: #{self.fps} milliseconds_since_last_tick: #{self.milliseconds_since_last_tick}"
  end
end

Fruits.new.show