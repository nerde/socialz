class TakeHome
  Error = Class.new(StandardError)

  include HTTParty
  base_uri 'https://takehome.io'

  def facebook
    parse(self.class.get('/facebook'))
  end

  def twitter
    parse(self.class.get('/twitter'))
  end

  def instagram
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
