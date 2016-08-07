class RenderSystem < ECS::System
  getter :ms_since_previous_render
  setter :ms_since_previous_render
  private getter :width
  private getter :height

  TARGET_FPS = 60
  TARGET_INTERVAL = 1000.0 / TARGET_FPS

  def initialize
    @ms_since_previous_render = 0.0
    @width = 80
    @height = 20
    @frames = 1
    @start = Time.now
    @default_sprite = Sprite.new(1, 1, ['X'])
  end

  def update(delta, manager : ECS::EntityManager)
    self.ms_since_previous_render += delta * 1000.0

    return if ms_since_previous_render < TARGET_INTERVAL

    screen = render_entities(manager)
    flush_terminal
    render_in_frame(title: "Lunar Lander", screen: screen)

    self.ms_since_previous_render -= TARGET_INTERVAL
    @frames += 1
  end

  private def render_entities(manager)
    screen = Array.new(width * height, ' ')

    manager.get_all_entities_with_component_of_type(Renderable).each do |entity|
      render_entity(screen, manager, entity)
    end

    screen
  end

  private def render_entity(screen, manager, entity)
    spatial_component = manager.get_component_of_type(entity, SpatialState)
    x = spatial_component.x.to_i - 1
    y = spatial_component.y.to_i - 1

    sprite = manager.get_component_of_type(entity, Sprite) || @default_sprite
    render_sprite(screen, x, y, sprite)
  end

  private def render_sprite(screen, x, y, sprite : Sprite)
    sprite.sprite.in_groups_of(sprite.w).reverse.each_with_index(y) do |chars, y|
      next if y < 0 || height < y

      chars.each_with_index(x) do |char, x|
        next if x < 0 || width < x

        index = y * width + x
        next if index < 0 || screen.size < index

        screen[index] = char || ' '
      end
    end
  end

  private def render_in_frame(screen, title = "")
    buffer = ""
    buffer += "*" * (width + 2) + "\n"
    buffer += "*" + (" " * 34) + title + (" " * 34) + "*" + "\n"
    buffer += "*" * (width + 2) + "\n"
    screen.in_groups_of(width).reverse.each do |line|
      buffer += "*" + line.join("") + "*" + "\n"
    end
    buffer += "*" * (width + 2) + "\n"
    buffer += $debug + " FPS: #{fps.to_i}\n"
    print buffer
  end

  private def flush_terminal
    print "\n" * 100
  end

  private def fps
    elapsed_time = (Time.now - @start)
    @frames.to_f * 1000.0 / elapsed_time.total_milliseconds
  end
end
