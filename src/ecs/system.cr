module ECS
  abstract class System
    abstract def update(delta : Float32, manager : EntityManager)
  end
end
