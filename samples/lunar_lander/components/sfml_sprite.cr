class SFMLSprite < ECS::Component
  getter :sprite
  getter :w
  getter :h

  def initialize(@w : Int32, @h : Int32, @texture : SF::Texture)
    super()

    @sprite = SF::Sprite.new(@texture)
  end

  def self.from_file(path)
    texture = SF::Texture.from_file(path)
    size = texture.size
    self.new(size.x, size.y, texture)
  end
end
