
class Oystercard
  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1
  MINIMUM_FARE = 1
  attr_reader :balance, :entry_station, :journey_history

  def initialize
    @balance = 0
    @journey_history = []
  end

  def top_up(amount)
    raise("Maximum limit £#{MAXIMUM_BALANCE} exceeded") if exceeds_limit?(amount)
    @balance += amount
  end

  def touch_in(station)
    fail("Insufficient funds, please top up") if insufficient_funds?
    @entry_station = station
  end

  def touch_out(station)
    deduct(MINIMUM_FARE)
    record_journey(@entry_station, station)
    @entry_station = nil
  end

  def in_journey?
    @entry_station != nil
  end

  private

  def record_journey(entry_station, exit_station)
    @journey_history << { entry: entry_station, exit: exit_station }
  end

  def deduct(fare)
    @balance -= fare
  end

  def exceeds_limit?(amount)
    @balance + amount > MAXIMUM_BALANCE
  end

  def insufficient_funds?
    @balance < MINIMUM_BALANCE
  end
end
