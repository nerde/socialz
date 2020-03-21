class ConcurrentTakeHome
  attr_reader :take_home, :tweets_future, :statuses_future, :photos_future

  def initialize(take_home = TakeHome.new)
    @take_home = take_home

    refresh
  end

  def refresh
    @tweets_future = Concurrent::Future.execute { take_home.tweets }
    @statuses_future = Concurrent::Future.execute { take_home.statuses }
    @photos_future = Concurrent::Future.execute { take_home.photos }
  end

  %i[tweets statuses photos].each do |key|
    define_method key do
      send("#{key}_future").value
    end
  end
end
