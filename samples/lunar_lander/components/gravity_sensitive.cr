class GravitySensitive < ECS::Component
  getter :landed
  setter :landed

  def initialize
    super

    @landed = false
  end
end
