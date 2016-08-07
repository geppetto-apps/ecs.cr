class EngineSystem < ECS::System
  def update(delta, manager : ECS::EntityManager)
    manager.get_all_entities_with_component_of_type(Engine).each do |entity|
      engine_component = manager.get_component_of_type(entity, Engine)
      fuel_component = manager.get_component_of_type(entity, Fuel)
      gravity_sensitive = manager.get_component_of_type(entity, GravitySensitive)

      location_component = manager.get_component_of_type(entity, SpatialState)
      if engine_component.on && fuel_component.remaining > 0
        renderable_component = manager.get_component_of_type(entity, Renderable)

        amount = engine_component.thrust * delta
        fuel_component.burn(amount)
        current_rotation = renderable_component.rotation

        location_component.dy += 15.0 * delta

        engine_component.on = false
      end

      if gravity_sensitive.landed
        location_component.dx = 0.0
      else
        location_component.dx += 15.0 * delta * engine_component.gimbal.to_i
      end
    end
  end
end
