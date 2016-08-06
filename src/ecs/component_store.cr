module ECS
  class ComponentStore
    private getter :store
    private setter :store

    alias EntCompHash = Hash(Int32, Array(Component))

    def initialize
      @store = Hash(String, EntCompHash).new do |hash, key|
        hash[key] ||= EntCompHash.new do |hash, key|
          hash[key] ||= Array(Component).new
        end
      end
    end

    def add(entity : Entity, component : Component)
      store[component.class.name][entity] << component
    end

    def has(entity : Entity, component : Component)
      store[component.class.name][entity].includes? component
    end

    def has_type(entity : Entity, klass : Component.class)
      store[klass.name][entity].any?
    end

    def with_type(klass : Component.class) : EntCompHash
      store[klass.name]
    end
  end
end
