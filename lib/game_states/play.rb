class Play < Chingu::GameState
  trait :timer

  attr_reader :hand

  def setup
    @level = Level.new options[:level]

    @factory_image = Image["factory.png"]
    @lane_image = Image["lane.png"]

    @hand = Hand.create
    @fruit_kinds = @level.fruits
    @fruit_creation_interval = 1000.0 / @level.fruits_per_second

    @level.monsters.each_with_index do |monster, i|
      Monster.create monster[1].merge(kind: monster[0], lane: i)
    end

    every(@fruit_creation_interval) do
      create_fruit
    end

    TimeLeft.create time: @level.time

    $window.caption = "Level #{@level.number}: #{@level.name}"

    self.input = {
      left_mouse_button: :grab_or_release,
      holding_left_mouse_button: :try_grab,
      released_left_mouse_button: :try_release,
    }
  end

  def reset
    Fruit.destroy_all
    Monster.destroy_all
    Hand.destroy_all
    TimeLeft.destroy_all
    Chingu::Text.destroy_all
    setup
  end

  def update
    super

    update_fruit_under_hand_and_in_hand
    update_fruits_eaten
  end

  def update_fruit_under_hand_and_in_hand
    if @fruit_in_hand
      @fruit_in_hand.x = $window.mouse_x - 10
      @fruit_in_hand.y = $window.mouse_y - 10
      return
    end

    fruit_under_hand = @hand.closest_collision(Fruit)
    if @fruit_under_hand != fruit_under_hand
      @fruit_under_hand.stop_blinking if @fruit_under_hand
      @fruit_under_hand = fruit_under_hand
      @fruit_under_hand.start_blinking if @fruit_under_hand
    end
  end

  def update_fruits_eaten
    Fruit.select { |f| f != @fruit_in_hand && f.y >= 420 }.each do |fruit|
      monster = Monster.select { |m| m.lane == fruit.lane }.first
      monster.eat fruit
    end
  end

  def draw
    super
    @factory_image.draw 40, 0, 20
    5.times do |i|
      @lane_image.draw 120 + 80 * i, 40, 1
    end
  end

  def create_fruit
    available_lanes = Set.new [0, 1, 2, 3, 4]
    Fruit.each do |f|
      available_lanes.delete f.lane if f.y < 35
    end

    return if available_lanes.empty?

    lane = available_lanes.to_a.sample
    Fruit.create lane: lane, kind: @fruit_kinds.sample, speed: 0.5
  end

  def grab_or_release
    return if @grabbing_nothing

    if @fruit_in_hand
      if $window.mouse_x < 120 || $window.mouse_x > 520 || $window.mouse_y < 40 || $window.mouse_y > 400
        return
      end

      new_lane = (($window.mouse_x - 120) / 80).floor

      # Adjust fruit's place if it collides with others
      Fruit.each do |f|
        if (f != @fruit_in_hand && f.lane == new_lane && (f.y - @fruit_in_hand.y).abs <= 33)
          # Check if there's space above or below
          new_y = @fruit_in_hand.y >= f.y ? f.y + 34 : f.y - 34
          return if new_y < 40 || new_y > 400

          Fruit.each do |f2|
            if (f2 != @fruit_in_hand && f2.lane == new_lane && (f2.y - new_y).abs <= 33)
              return
            end
          end
          @fruit_in_hand.y = new_y
          break
        end
      end

      @fruit_in_hand.lane = new_lane
      @fruit_in_hand.start_moving
      @fruit_in_hand.zorder -= 1
      @fruit_in_hand = nil
      @hand.release
      return
    end

    return unless @fruit_under_hand && @fruit_under_hand.can_be_grabbed?

    @fruit_in_hand = @fruit_under_hand
    @fruit_in_hand.stop_moving
    @fruit_in_hand.stop_blinking
    @fruit_in_hand.zorder += 1
    @hand.grab
  end

  def try_grab
    if !@fruit_in_hand && !@fruit_under_hand
      @hand.grab
      @grabbing_nothing = true
    end
  end

  def try_release
    if @grabbing_nothing
      @hand.release
      @grabbing_nothing = false
    end
  end

  def time_over
    push_game_state Victory
  end
end