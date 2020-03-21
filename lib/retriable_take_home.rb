class RetriableTakeHome
  attr_reader :take_home, :max_tries

  def initialize(take_home = TakeHome.new, max_tries: 5)
    @take_home = take_home
    @max_tries = max_tries
  end

  %i[tweets statuses photos].each do |key|
    define_method key do
      tries = 0
      begin
        take_home.send(key)
      rescue TakeHome::Error
        tries += 1
        retry if tries < max_tries

        raise
      end
    end
  end
end
