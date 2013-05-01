class Defeat < Chingu::GameState
  traits :timer

  def setup
    @game_object = options[:game_object]
    @text = Chingu::Text.create text: "Perdiste! :-(", x: 232, y: 200, zorder: 200, font: "verdana", size: 40

    after(3000) {
      pop_game_state setup: false
      current_game_state.reset
      push_game_state LevelDescription.new level: current_game_state.level
    }
  end

  def draw
    super
    previous_game_state.draw
    if @game_object
      47.step(50, 0.25) do |r|
        draw_circle @game_object.x, @game_object.y, r, Gosu::Color::RED, 91
      end
    end
  end

  def update
    super
    previous_game_state.hand.update
  end
end