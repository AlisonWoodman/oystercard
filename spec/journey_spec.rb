require 'journey'

describe Journey do
  subject(:journey) { described_class.new(:entry_station) }
  let(:station_0) { double(:station) }
  describe '#initialize' do
    it 'creates a journey with an entry station' do
      expect(journey.entry_station).to eq(:entry_station)
    end
  end

  describe '#complete_journey' do
    it 'populates exit station variable' do
      expect { journey.complete_journey(:station_0) }
        .to change { journey.exit_station }.from(nil).to(:station_0)
    end
  end

  # describe '#fare' do
  #   it 'returns minimum fare when journey is completed successfully' do
  #   end
  # end
end
