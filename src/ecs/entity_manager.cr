module ECS
  class EntityManager
    private getter :component_store

    def initialize
      @entity_id = 0
      @component_store = ComponentStore.new
    end

    def create_entity : Entity
      @entity_id += 1
    end

    def add_component(entity : Entity, component : Component)
      component_store.add(entity, component)
    end

    def has_component_of_type(entity : Entity, klass : Component.class)
      component_store.has_type(entity, klass)
    end

    def has_component(entity : Entity, component : Component)
      component_store.has(entity, component)
    end

    def get_all_entities_with_component_of_type(klass : Component.class)
      component_store.with_type(klass).keys
    end

    def get_component_of_type(entity : Entity, klass : T.class) forall T
      component_store.with_type(klass)[entity].first.as(T)
    rescue IndexError
      raise "Entity ##{entity} has no #{klass.name} component"
    end

    def get_component_of_type?(entity : Entity, klass : T.class) forall T
      component_store.with_type(klass)[entity].first.as(T)
    rescue IndexError
      nil
    end
  end
end
