# These shared example test that a subject's accessor method is:
#
#   A) Publicly exposed
#   B) Not nil
#   c) Result "equal" to the `let` with the same name in context
#
# @param [Symbol] Method name as symbol
# @param [*args] Arbitrary arguments to pass to the `send` call
#
RSpec.shared_examples 'a public accessor method' do |target, *args|
  let(:result) do
    subject.public_send(target, *(args.map { |i| public_send(i) }))
  end

  let(:expected) do
    public_send(target)
  end

  it "publicly exposes ##{target}" do
    expect(result).not_to be_nil
  end

  it 'has expected values' do
    expect(result).to eq(expected)
  end
end

RSpec.shared_examples 'a helper which yields message of kind' do |klass, target, *args|
  let(:klazz) { public_send(klass) }

  let(:instance) do
    subject.public_send(target, *(args.map { |i| public_send(i) }))
  end

  it_behaves_like 'a message instance of kind', :klazz, :instance
end

RSpec.shared_examples 'a message instance of kind' do |klass, target|
  let(:kind) { public_send(klass) }
  let(:victim) { public_send(target) }

  it "returns an instance of #{klass}" do
    expect(victim).to be_a(kind)
  end

  context '#serialization' do
    it 'serializes and deserializes properly' do
      expect(victim.to_session).to be_a(String)

      another_victim = victim.class.from_session(victim.to_session)

      expect(another_victim).to eq(victim)
    end
  end

  # Note: inherits default_message from calling context
  context '#message' do
    it 'has the expected message' do
      expect(victim.message).to eq(default_message)
    end
  end

  context '#eql?' do
    it 'equals another message instance with the same string' do
      another_victim = victim.dup
      expect(another_victim).to eq(victim)
      expect(another_victim.__id__).not_to eq(victim.__id__)
    end
  end

  context '#match?' do
    it 'matches the string value' do
      expect(victim).to match(victim.message)
    end
  end

  context '#type?' do
    it 'exposes its type helper properly' do
      expect(victim.public_send("#{victim.level}?")).to be_truthy
    end
  end
end
