require "../spec_helper"

Spec2.describe ECS::EntityManager do
  subject { described_class.new }

  it "should be able to create an entity" do
    actual = subject.create_entity
    expect(actual).to eq 1
  end

  it "should assign serial numbers to entities" do
    subject.create_entity
    actual = subject.create_entity
    expect(actual).to eq 2
  end

  it "should be able to add a component to an entity" do
    entity = subject.create_entity
    component = MyComponent.new

    subject.add_component(entity, component)
  end

  it "should know when an entity has a component" do
    entity = subject.create_entity
    component = MyComponent.new

    expect(subject.has_component(entity, component)).to eq false
    subject.add_component(entity, component)
    expect(subject.has_component(entity, component)).to eq true
  end

  it "should know when an entity has a component of a specific type" do
    entity = subject.create_entity
    component = MyComponent.new

    expect(subject.has_component_of_type(entity, MyComponent)).to eq false
    subject.add_component(entity, component)
    expect(subject.has_component_of_type(entity, MyComponent)).to eq true
  end

  it "can retrieve all entities with a specific component type" do
    entity_a = subject.create_entity
    subject.add_component(entity_a, MyComponent.new)
    entity_b = subject.create_entity
    subject.add_component(entity_b, MyComponent.new)

    expect(
      subject.get_all_entities_with_component_of_type(MyComponent)
    ).to eq [
      entity_a,
      entity_b,
    ]
  end
end
