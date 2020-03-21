class HomeController < ApplicationController
  def index
    @take_home = TakeHome.new

    @tweets = @take_home.tweets
    @statuses = @take_home.statuses
    @photos = @take_home.photos
  end
end
