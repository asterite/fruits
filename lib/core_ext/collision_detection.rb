module Chingu::Traits::CollisionDetection
  def closest_collision(*klasses)
    target = nil
    target_distance = nil
    each_collision(*klasses) do |me, other|
      distance = Gosu.distance(me.x, me.y, other.x, other.y)
      if !target || distance < target_distance
        target = other
        target_distance = distance
      end
    end
    target
  end
end