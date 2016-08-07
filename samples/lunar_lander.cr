# Based on:
# https://cbpowell.wordpress.com/2012/12/06/entity-component-game-programming-using-jruby-and-libgdx-part-3/
require "../src/ecs"
require "./lunar_lander/components/*"
require "./lunar_lander/systems/*"

$debug = ""

module LunarLander
  class Application
    def self.main
      systems = [
        InputSystem.new,
        EngineSystem.new,
        PhysicsSystem.new,
        RenderSystem.new,
      ]

      manager = ECS::EntityManager.new

      entity = manager.create_entity
      manager.add_component(entity, Engine.new)
      manager.add_component(entity, Fuel.new(128.0))
      manager.add_component(entity, SpatialState.new(5.0, 5.0))
      manager.add_component(entity, Renderable.new)
      manager.add_component(entity, GravitySensitive.new)
      manager.add_component(entity, Sprite.from_file(
        File.expand_path("../lunar_lander/sprites/lander.txt", __FILE__)
      ))

      game_loop = ECS::GameLoop.new(target_fps: 60)
      game_loop.run do |delta|
        systems.each do |system|
          system.update(delta, manager)
        end
      end
    end
  end
end

LunarLander::Application.main
