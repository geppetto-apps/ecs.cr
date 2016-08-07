class Engine < ECS::Component
  getter :on
  getter :gimbal
  setter :on
  setter :gimbal

  def initialize
    super

    @on = true
    @gimbal = Gimbal::None
  end

  def thrust
    on ? 1 : 0
  end

  enum Gimbal
    Left  = -1
    None  =  0
    Right =  1
  end
end
