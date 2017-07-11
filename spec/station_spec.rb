require 'station'

describe Station do
  subject(:station) {described_class.new(:name, :zone)}

  it 'initializes with a name variable' do
    expect(station).to respond_to (:name)
  end

  it 'initializes with a zone variable' do
    expect(station).to respond_to (:zone)
  end
end
