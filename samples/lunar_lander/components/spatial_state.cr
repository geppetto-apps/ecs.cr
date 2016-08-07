class SpatialState < ECS::Component
  getter :x
  setter :x
  getter :y
  setter :y
  getter :dx
  getter :dy
  setter :dx
  setter :dy

  def initialize(@x : Float64, @y : Float64)
    super()

    @dx = 0.0
    @dy = 0.0
  end
end
