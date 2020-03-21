class CachedTakeHome
  attr_reader :take_home, :cache, :prefix, :ttl

  def initialize(take_home = TakeHome.new, cache: Rails.cache, prefix: 'take_home__', ttl: 15.minutes)
    @take_home = take_home
    @cache = cache
    @prefix = prefix
    @ttl = ttl
  end

  %i[tweets statuses photos].each do |key|
    define_method key do
      cache.fetch("#{prefix}#{key}", expires_in: ttl) { take_home.send(key) }
    end
  end
end
