class TakeHome
  Error = Class.new(StandardError)

  include HTTParty
  base_uri 'https://takehome.io'

  def tweets
    parse(self.class.get('/twitter'))
  end

  def statuses
    parse(self.class.get('/facebook'))
  end

  def photos
    parse(self.class.get('/instagram'))
  end

  private

  def parse(response)
    raise Error.new("Request failed (status #{response.code}): #{response.body}") unless response.ok?

    JSON.parse(response.body)
  rescue JSON::ParserError => e
    Error.new("Invalid response: #{e.message}. Body: #{response.body}")
  end
end
