class LevelDescription < Chingu::GameState
  include Chingu::Helpers::GFX

  def setup
    @level = options[:level]
    @texts = []
    @texts.push Chingu::Text.create text: "Nivel #{@level.number}: #{@level.name}", x: 120, y: 150, max_width: 400, zorder: 91, font: "verdana", size: 24, color: Gosu::Color::BLACK
    @texts.push Chingu::Text.create text: @level.description, x: 120, y: 180, max_width: 400, zorder: 91, font: "verdana", size: 22, color: Gosu::Color::BLACK
    @texts.push Chingu::Text.create text: "Empezar", x: 440, y: 300, zorder: 91, font: "verdana", size: 26, color: Gosu::Color::BLACK

    self.input = {left_mouse_button: :click}
  end

  def draw
    super
    previous_game_state.draw
    draw_description
  end

  def draw_description
    fill_rect Chingu::Rect.new(100, 140, 440, 200), Gosu::Color.argb(0xFFFFAE00), 90
    fill_rect Chingu::Rect.new(104, 144, 432, 192), Gosu::Color.argb(0xFFFFDF5E), 90
    fill_rect Chingu::Rect.new(430, 300, 100, 30), Gosu::Color.argb(0xFF000000), 90

    color = @start_hovered ? Gosu::Color.argb(0xFFFFAAAA) : Gosu::Color.argb(0xFFFFFFFF)
    fill_rect Chingu::Rect.new(434, 304, 92, 22), color, 90
  end

  def update
    super
    previous_game_state.hand.update
    @start_hovered = $window.mouse_x >= 445 && $window.mouse_x <= 545 && $window.mouse_y >= 315 && $window.mouse_y <= 345
  end

  def click
    if @start_hovered
      @texts.each(&:destroy)
      pop_game_state setup: false
    end
  end
end