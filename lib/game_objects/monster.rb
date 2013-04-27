class Monster < Chingu::GameObject
  def setup
    @kind = options[:kind].new(self)
    self.lane = options[:lane]
    self.y = 420
    self.zorder = 30
  end

  def lane=(lane)
    self.x = 160 + 80 * lane
  end
end

class SweetTooth
  def initialize(monster)
    @monster = monster
    @monster.image = Image["sweet_tooth.png"]
  end
end