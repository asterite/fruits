class Victory < Chingu::GameState
  traits :timer

  def setup
    @text = Chingu::Text.create text: "Level complete!", x: 212, y: 200, font: "verdana", size: 40

    after(2000) {
      previous_game_state.options[:level] += 1
      previous_game_state.reset
      pop_game_state
    }
  end

  def draw
    super
    previous_game_state.draw
  end
end