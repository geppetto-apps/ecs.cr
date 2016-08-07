class InputSystem < ECS::System
  def update(delta, manager : ECS::EntityManager)
    manager.get_all_entities_with_component_of_type(Engine).each do |entity|
      engine_component = manager.get_component_of_type(entity, Engine)
      engine_component.on = SF::Keyboard.is_key_pressed(SF::Keyboard::Space)
      engine_component.gimbal = if SF::Keyboard.is_key_pressed(SF::Keyboard::Left)
                                  Engine::Gimbal::Left
                                elsif SF::Keyboard.is_key_pressed(SF::Keyboard::Right)
                                  Engine::Gimbal::Right
                                else
                                  Engine::Gimbal::None
                                end
    end
  end
end
