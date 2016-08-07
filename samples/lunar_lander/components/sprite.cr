class Sprite < ECS::Component
  getter :sprite
  setter :sprite
  getter :w
  getter :h

  def initialize(@w : Int32, @h : Int32, @sprite : Array(Char))
    super()

    validate_sprite_size
  end

  def self.from_file(path)
    text = File.read_lines(path).map do |line|
      line.delete('\n')
    end

    w = text.first.size
    h = text.size

    p w
    p h

    self.new(
      w,
      h,
      text.join().chars
    )
  end

  private def validate_sprite_size
    expected = w * h
    actual = sprite.size
    return if actual == expected

    raise "Invalid sprite size. Expected: #{expected}, Got: #{actual}"
  end
end
