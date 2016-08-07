module ECS
  class GameLoop
    getter :target_fps
    private getter :target_interval
    private getter :delta

    def initialize(@target_fps = 60)
      @delta = 0.0
      @target_interval = 1.0
      @target_interval /= target_fps
    end

    def run
      @delta = 0.0
      loop do
        past = Time.now

        if 0.0 < delta && delta < target_interval
          sleep 0.001
        else
          tick do
            yield(delta)
          end
          @delta = 0
        end

        @delta += (Time.now - past).ticks / 10000000.0
      end
    end

    def tick
      yield(delta)
    end
  end
end
