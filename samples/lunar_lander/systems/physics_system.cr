class PhysicsSystem < ECS::System
  GRAVITY = 10.0
  DRAG = 0.2

  def update(delta, manager : ECS::EntityManager)
    manager.get_all_entities_with_component_of_type(GravitySensitive).each do |entity|
      spatial_state = manager.get_component_of_type(entity, SpatialState)
      gravity_sensitive = manager.get_component_of_type(entity, GravitySensitive)

      apply_forces(spatial_state, delta)
      cap_coordinates(spatial_state)

      gravity_sensitive.landed = spatial_state.y == 1

      apply_gravity(spatial_state, delta)
      apply_drag(spatial_state, delta)
    end
  end

  private def apply_forces(spatial_state, delta)
    spatial_state.x += delta * spatial_state.dx
    spatial_state.y += delta * spatial_state.dy
  end

  private def cap_coordinates(spatial_state)
    # Cap coordinates
    if spatial_state.x < 1
      spatial_state.x = 1.0
    elsif spatial_state.x > 80
      spatial_state.x = 80.0
    end
    if spatial_state.y < 1
      spatial_state.y = 1.0
      spatial_state.dy = 0.0
    end
  end

  private def apply_gravity(spatial_state, delta)
    spatial_state.dy -= GRAVITY * delta
  end

  private def apply_drag(spatial_state, delta)
    spatial_state.dx *= (1.0 - delta * DRAG)
  end
end
