class TimeLeft < Chingu::BasicGameObject
  trait :timer

  attr_accessor :time

  def setup
    @time = options[:time]
    @text = Chingu::Text.create text: "Tiempo: #{formatted_time}", x: 10, y: 0, zorder: 200, font: "verdana", size: 24, color: Gosu::Color::WHITE

    every(1000) do
      if @time == 1
        $window.current_game_state.time_over
      end
      @time -= 1 if @time > 0
      @text.text = "Tiempo: #{formatted_time}"
    end
  end

  def formatted_time
    seconds = @time % 60
    minutes = (@time - seconds) / 60
    seconds = "0#{seconds}" if seconds < 10
    "#{minutes}:#{seconds}"
  end
end