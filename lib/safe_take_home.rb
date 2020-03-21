class SafeTakeHome
  attr_reader :take_home, :default

  def initialize(take_home = TakeHome.new, default: [])
    @take_home = take_home
    @default = default
  end

  %i[tweets statuses photos].each do |key|
    define_method key do
      begin
        take_home.send(key)
      rescue TakeHome::Error
        default
      end
    end
  end
end
