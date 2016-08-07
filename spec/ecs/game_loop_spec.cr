require "../spec_helper"

Spec2.describe ECS::GameLoop do
  subject { described_class.new }

  it "should have a default target fps" do
    expect(subject.target_fps).to eq 60
  end

  it "should be possible to set target fps" do
    game_loop = described_class.new(30)
    expect(game_loop.target_fps).to eq 30
  end

  it "should be possible to advance the game one tick" do
    advanced = false

    subject.tick do |_|
      advanced = true
    end

    expect(advanced).to eq true
  end

  # TODO: Figure out how this could be tested further. I have no idea :)
end
