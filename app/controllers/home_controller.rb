class HomeController < ApplicationController
  def index
    @take_home = ConcurrentTakeHome.new(SafeTakeHome.new(CachedTakeHome.new(RetriableTakeHome.new)))

    @tweets = @take_home.tweets
    @statuses = @take_home.statuses
    @photos = @take_home.photos
  end
end
