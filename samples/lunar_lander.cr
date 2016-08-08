# Based on:
# https://cbpowell.wordpress.com/2012/12/06/entity-component-game-programming-using-jruby-and-libgdx-part-3/
require "../src/ecs"
require "./lunar_lander/components/*"
require "./lunar_lander/systems/*"

$debug = ""

module LunarLander
  class Application
    def self.main
      window = SF::RenderWindow.new(
        SF::VideoMode.new(width: 640 * 2, height: 480 * 2),
        "Lunar Lander"
      )

      systems = [
        SFMLInputSystem.new,
        EngineSystem.new,
        PhysicsSystem.new,
        SFMLRenderSystem.new(window),
      ]

      manager = ECS::EntityManager.new

      entity = manager.create_entity
      manager.add_component(entity, Engine.new)
      manager.add_component(entity, Fuel.new(128.0))
      manager.add_component(entity, SpatialState.new(5.0, 5.0))
      manager.add_component(entity, Renderable.new)
      manager.add_component(entity, GravitySensitive.new)
      manager.add_component(entity, SFMLSprite.from_file(
        File.expand_path("../lunar_lander/sprites/lander.png", __FILE__)
      ))

      clock = SF::Clock.new

      while window.open?
        while event = window.poll_event
          if event.is_a? SF::Event::Closed
            window.close
            Process.exit(0)
          end
        end

        delta = clock.elapsed_time.as_seconds.to_f
        systems.each do |system|
          system.update(delta, manager)
        end
        clock.restart
      end

      # game_loop = ECS::GameLoop.new(target_fps: 60)
      # game_loop.run do |delta|
      #   systems.each do |system|
      #     system.update(delta, manager)
      #   end
      # end
    end
  end
end

LunarLander::Application.main
