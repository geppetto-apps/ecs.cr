class Renderable < ECS::Component
  getter :rotation
  setter :rotation

  def initialize
    super

    @rotation = 0
  end
end
