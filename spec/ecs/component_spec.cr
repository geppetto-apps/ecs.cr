require "../spec_helper"

Spec2.describe ECS::Component do
  subject { MyComponent.new }

  it "should have an id" do
    expect(subject.id)
  end
end
