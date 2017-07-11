require 'oystercard'

describe Oystercard do
  subject(:card) { described_class.new }
  ARBITRARY_TOP_UP = 10
  ARBITRARY_FARE = 2

  describe '#initialize' do
    it 'creates a card with a zero balance' do
      expect(card.balance).to eq 0
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
    context "insufficient funds" do
      it 'raises an error if the card has insufficient funds' do
        expect{ card.touch_in }.to raise_error("Insufficient funds, please top up")
      end
    end
    context "sufficient funds" do
      before do
        card.top_up(described_class::MINIMUM_BALANCE)
        card.touch_in
      end
      it { should be_in_journey }
    end
  end

  describe '#touch_out' do
    it 'touches out' do
      card.touch_out
      should_not be_in_journey
    end

    it 'deducts the fare from the card balance' do
      expect { card.touch_out }.to change{ card.balance }.by(-described_class::MINIMUM_FARE)
    end
  end

  describe '#in_journey?' do
    it 'returns false for a new card' do
       should_not be_in_journey
    end
  end
end
