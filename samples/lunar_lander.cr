# Based on:
# https://cbpowell.wordpress.com/2012/12/06/entity-component-game-programming-using-jruby-and-libgdx-part-3/
require "crsfml"
require "../src/ecs"

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

class GravitySensitive < ECS::Component
end

class Renderable < ECS::Component
  getter :rotation
  setter :rotation

  def initialize
    super

    @rotation = 0
  end
end

class EngineSystem < ECS::System
  def update(delta, manager : ECS::EntityManager)
    manager.get_all_entities_with_component_of_type(Engine).each do |entity|
      engine_component = manager.get_component_of_type(entity, Engine)
      fuel_component = manager.get_component_of_type(entity, Fuel)

      location_component = manager.get_component_of_type(entity, SpatialState)
      if engine_component.on && fuel_component.remaining > 0
        renderable_component = manager.get_component_of_type(entity, Renderable)

        amount = engine_component.thrust * delta
        fuel_component.burn(amount)
        current_rotation = renderable_component.rotation

        location_component.dy += 15.0

        engine_component.on = false
      end

      location_component.dx = 4.0 * engine_component.gimbal.to_i
    end
  end
end

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

class PhysicsSystem < ECS::System
  def update(delta, manager : ECS::EntityManager)
    manager.get_all_entities_with_component_of_type(SpatialState).each do |entity|
      spatial_state = manager.get_component_of_type(entity, SpatialState)

      # Apply forces
      spatial_state.x += delta * spatial_state.dx
      spatial_state.y += delta * spatial_state.dy

      # Cap coordinates
      if spatial_state.x < 1
        spatial_state.x = 1.0
      elsif spatial_state.x > 80
        spatial_state.x = 80.0
      end
      if spatial_state.y < 1
        spatial_state.y = 1.0
      elsif spatial_state.y > 20
        spatial_state.y = 20.0
      end

      # Apply gravity
      spatial_state.dy = -10.0
    end
  end
end

class RenderSystem < ECS::System
  getter :ms_since_previous_render
  setter :ms_since_previous_render

  def initialize
    @ms_since_previous_render = 0.0
  end

  def update(delta, manager : ECS::EntityManager)
    self.ms_since_previous_render += delta * 1000.0

    if ms_since_previous_render > 50
      # Flush the screen
      print "\n" * 100

      width = 80
      height = 20
      screen = Array.new(width * height, ' ')

      manager.get_all_entities_with_component_of_type(Renderable).each do |entity|
        spatial_component = manager.get_component_of_type(entity, SpatialState)
        x = spatial_component.x.to_i - 1
        y = spatial_component.y.to_i - 1
        screen[y * width + x] = 'X'
      end

      buffer = ""
      buffer += "*" * (width + 2) + "\n"
      buffer += "*" + (" " * 34) + "Lunar Lander" + (" " * 34) + "*" + "\n"
      buffer += "*" * (width + 2) + "\n"
      screen.in_groups_of(width).reverse.each do |line|
        buffer += "*" + line.join("") + "*" + "\n"
      end
      buffer += "*" * (width + 2) + "\n"
      buffer += $debug + "\n"
      print buffer

      self.ms_since_previous_render -= 50
    end
  end
end

systems = [
  InputSystem.new,
  EngineSystem.new,
  PhysicsSystem.new,
  RenderSystem.new
]

manager = ECS::EntityManager.new

$debug = ""
entity = manager.create_entity
manager.add_component(entity, Engine.new)
manager.add_component(entity, Fuel.new(128.0))
manager.add_component(entity, SpatialState.new(5.0, 5.0))
manager.add_component(entity, Renderable.new)

delta = 0.0

loop do
  past = Time.now
  systems.each do |system|
    system.update(delta, manager)
  end
  delta = (Time.now - past).ticks / 10000000.0
end
