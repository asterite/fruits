require 'bundler/setup'
require 'chingu'
require 'require_all'

require_all "lib"

include Gosu

# Image.autoload_dirs << File.expand_path('../../media',  __FILE__)

class Fruits < Chingu::Window
  def initialize
    super(640, 480, false)

    self.input = { :escape => :exit }

    push_game_state Play
  end

  def update
    super
    self.caption = "FPS: #{self.fps} milliseconds_since_last_tick: #{self.milliseconds_since_last_tick}"
  end
end

Fruits.new.show