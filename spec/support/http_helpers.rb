module HTTPHelpers
  def base_url
    ENV["BATTLESHIFT_BASE_URL"] || "http://localhost:3000"
  end

  def conn
    @conn ||= Faraday.new(base_url) do |faraday|
      faraday.headers["X-API-Key"] = ENV["BATTLESHIFT_API_KEY"]
      faraday.adapter  Faraday.default_adapter
    end
  end

  def post_json(endpoint, payload, api_key = ENV["BATTLESHIFT_API_KEY"])
    request = conn.post do |req|
      req.url endpoint
      req.headers["X-API-Key"] = api_key
      req.headers["CONTENT_TYPE"] = "application/json"
      req.body = payload
    end

    JSONResponseHandler.new(request)
  end

  def get_json(endpoint, api_key = ENV["BATTLESHIFT_API_KEY"])
    conn.headers["X-API-Key"] = api_key
    request = conn.get(endpoint)
    JSONResponseHandler.new(request)
  end

  def create_game(options = { opponent_email: ENV["BATTLESHIFT_OPPONENT_EMAIL"] })
    endpoint = "/api/v1/games"
    payload = options.to_json
    response = post_json(endpoint, payload)
  end

  def opponent_key
    ENV["BATTLESHIFT_OPPONENT_API_KEY"]
  end
end

class JSONResponseHandler
  attr_reader :faraday_response

  def initialize(faraday_response)
    @faraday_response = faraday_response
  end

  def body
    JSON.parse(faraday_response.body, symbolize_names: true)
  end

  def status
    faraday_response.status
  end
end
