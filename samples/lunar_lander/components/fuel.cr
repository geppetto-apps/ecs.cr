class Fuel < ECS::Component
  getter :remaining

  def initialize(@remaining : Float64)
    super()
  end

  def burn(qty)
    @remaining -= qty.round
    @remaining = 0 if @remaining < 0
  end
end
