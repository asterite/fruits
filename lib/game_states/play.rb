class Play < Chingu::GameState
  trait :timer

  def setup
    @factory_image = Image["factory.png"]
    @lane_image = Image["lane.png"]

    @hand = Hand.create
    @kinds = [Apple, Banana, Cherry, Lemon, Lime, Orange, Watermelon]

    5.times.map do |i|
      Monster.create lane: i, kind: SweetTooth, patience: 100, energy: 50
    end

    every(1000) do
      Fruit.create lane: Random.rand(5), kind: @kinds.sample, speed: 0.6
    end

    self.input = {
      left_mouse_button: :grab_or_release,
      holding_left_mouse_button: :try_grab,
      released_left_mouse_button: :try_release,
    }
  end

  def update
    super

    update_fruit_under_hand_and_in_hand
    update_fruits_eaten
  end

  def update_fruit_under_hand_and_in_hand
    fruit_under_hand = @hand.closest_collision(Fruit)

    if @fruit_under_hand != fruit_under_hand
      @fruit_under_hand.stop_blinking if @fruit_under_hand
      @fruit_under_hand = fruit_under_hand
      @fruit_under_hand.start_blinking if @fruit_under_hand
    end

    if @fruit_in_hand
      @fruit_in_hand.x = $window.mouse_x - 10
      @fruit_in_hand.y = $window.mouse_y - 10
    end
  end

  def update_fruits_eaten
    Fruit.select { |f| f.y >= 420 }.each do |fruit|
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

  def grab_or_release
    return if @grabbing_nothing

    if @fruit_in_hand
      if $window.mouse_x < 120 || $window.mouse_x > 520 || $window.mouse_y < 40 || $window.mouse_y > 400
        return
      end

      @fruit_in_hand.lane = (($window.mouse_x - 120) / 80).floor
      @fruit_in_hand.start_moving
      @fruit_in_hand = nil
      @hand.release
      return
    end

    return unless @fruit_under_hand && @fruit_under_hand.can_be_grabbed?

    @fruit_in_hand = @fruit_under_hand
    @fruit_in_hand.stop_moving
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
end