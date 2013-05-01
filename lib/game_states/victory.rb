class Victory < Chingu::GameState
  traits :timer

  def setup
    text1 = "Ganaste! :-)"
    width1 = Gosu::Font.new($window, "verdana", 40).text_width(text1)

    Chingu::Text.create text: text1, x: 320 - width1 / 2, y: 200, zorder: 200, font: "verdana", size: 40, color: Gosu::Color::BLUE

    after(3000) {
      pop_game_state setup: false
      current_game_state.advance_to_next_level
      push_game_state LevelDescription.new level: current_game_state.level
    }
  end

  def draw
    super
    previous_game_state.draw
  end

  def update
    super
    previous_game_state.hand.update
  end
end