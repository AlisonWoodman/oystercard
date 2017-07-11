require 'oystercard'

describe Oystercard do
  subject(:card) { described_class.new }
  let(:station_0) { double(:station) }
  let(:station_1) { double(:station) }
  let(:loaded_card) { described_class.new}

  ARBITRARY_TOP_UP = 10
  ARBITRARY_FARE = 2
  before {loaded_card.top_up(ARBITRARY_TOP_UP)}

  describe '#initialize' do
    it 'creates a card with a zero balance' do
      expect(card.balance).to eq 0
    end

    it 'creates a card with an empty array of journeys' do
      expect(card.journey_history).to be_empty
    end
  end

  describe '#top_up' do
    it 'does not allow card to hold more than the limit' do
      expect { card.top_up(described_class::MAXIMUM_BALANCE + 1) }
        .to raise_error("Maximum limit £#{described_class::MAXIMUM_BALANCE} exceeded")
    end

    it 'tops up the card with the given amount' do
      expect { card.top_up(ARBITRARY_TOP_UP) }.to change { card.balance }.by(ARBITRARY_TOP_UP)
    end
  end

  describe '#touch_in' do
    context "sufficient funds" do
      before {loaded_card.touch_in(:station_0)}
      it 'card is set to in journey' do
        expect(loaded_card).to be_in_journey
      end
      it 'records entry station upon' do
        expect(loaded_card.entry_station).to eq :station_0
    end
  end
    context "insufficient funds" do
      it 'raises an error if the card has insufficient funds' do
        expect{ card.touch_in(:station_0) }.to raise_error("Insufficient funds, please top up")
      end
    end
  end

  describe '#touch_out' do
    before { loaded_card.touch_in(:station_0) }

    it 'touches out' do
      card.touch_out(:station_1)
      should_not be_in_journey
    end

    it 'deducts the fare from the card balance' do
      expect { card.touch_out(:station_1) }.to change{ card.balance }.by(-described_class::MINIMUM_FARE)
    end

    it 'logs the journey in journey history' do
      expect { loaded_card.touch_out(:station_1) }
        .to change { loaded_card.journey_history }.from([]).to([{ entry: :station_0, exit: :station_1 }])
    end

    it 'sets entry_station to nil' do
      loaded_card.touch_out(:station_1)
      expect(loaded_card.entry_station).to eq nil
    end
  end

  describe '#in_journey?' do
    it 'returns false for a new card' do
       should_not be_in_journey
    end
  end
end
