class Hand < Chingu::GameObject
  traits :bounding_box, :collision_detection

  def setup
    @hand_image = Image["hand.png"]
    @hand_grab_image = Image["hand_grab.png"]
    @hand_shadow_image = Image["hand_shadow.png"]
    @hand_grab_shadow_image = Image["hand_grab_shadow.png"]

    @shadow_image = @hand_shadow_image

    self.image = @hand_image
    self.zorder = 100

    cache_bounding_box
  end

  def update
    super
    self.x = $window.mouse_x
    self.y = $window.mouse_y
  end

  def draw
    super
    @shadow_image.draw(x - image.width / 2 - 4, y - image.height / 2 - 4, 90)
  end

  def grab
    @grabbing = true
    self.image = @hand_grab_image
    @shadow_image = @hand_grab_shadow_image
  end

  def release
    @grabbing = true
    self.image = @hand_image
    @shadow_image = @hand_shadow_image
  end
end