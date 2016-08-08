require "crsfml"

class SFMLRenderSystem < ECS::System
  getter :ms_since_previous_render
  setter :ms_since_previous_render
  private getter :width
  private getter :height
  private getter :window
  private getter :ratio

  TARGET_FPS      = 60
  TARGET_INTERVAL = 1000.0 / TARGET_FPS

  def initialize(@window : SF::RenderWindow)
    @ms_since_previous_render = 0.0
    @width = 80
    @height = 20
    @frames = 1
    @ratio = 20
    @start = Time.now
  end

  def update(delta, manager : ECS::EntityManager)
    self.ms_since_previous_render += delta * 1000.0

    return if ms_since_previous_render < TARGET_INTERVAL

    window.clear(SF::Color::Black)
    render_entities(manager)
    window.display

    self.ms_since_previous_render -= TARGET_INTERVAL
    @frames += 1
  end

  private def render_entities(manager)
    manager.get_all_entities_with_component_of_type(SFMLSprite).each do |entity|
      render_entity(nil, manager, entity)
    end
  end

  private def render_entity(screen, manager, entity)
    sprite_comp = manager.get_component_of_type(entity, SFMLSprite)
    spatial = manager.get_component_of_type(entity, SpatialState)
    sprite = sprite_comp.sprite
    x = (spatial.x * ratio).to_i
    y = window.size.y
    y -= (spatial.y * ratio).to_i
    y -= sprite_comp.h
    sprite.position = SF::Vector2.new(x, y)
    window.draw(sprite_comp.sprite)
  end

  private def fps
    elapsed_time = (Time.now - @start)
    @frames.to_f * 1000.0 / elapsed_time.total_milliseconds
  end
end
