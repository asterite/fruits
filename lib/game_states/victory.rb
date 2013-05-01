class Victory < Chingu::GameState
  traits :timer

  def setup
    @text = Chingu::Text.create text: "Nivel completo!", x: 212, y: 200, zorder: 200, font: "verdana", size: 40

    after(3000) {
      pop_game_state setup: false
      previous_game_state.advance_to_next_level
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