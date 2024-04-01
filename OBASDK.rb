require 'httparty'
require 'json'

class OBAError < StandardError
end

class OBASDK
  include HTTParty
  attr_accessor :base_url, :api_key

  def initialize(api_key="TEST")
    @base_url = "https://api.pugetsound.onebusaway.org"
    @api_key = api_key
  end

  def request_endpoint(url)
    log("Request URL: "+url)
    response = make_request(url)
    decode_response(response, nil) #replace with Vehicle Object
  end

  def url_builder(endpoint)
    url = "#{base_url}#{endpoint}?key=#{api_key}"
    return url
  end

  def get_current_time()
    endpoint = "/api/where/current-time.json"
    url = url_builder(endpoint)
    request_endpoint(url)

  end

  def get_vehicle(vehicle_id)
    # url = url_builder.get_vehicle_url(vehicle_id)
    endpoint = "/api/where/vehicle/#{vehicle_id}.json"
    url = url_builder(endpoint)
    request_endpoint(url)
  end

  def get_vehicle_trip(vehicle_id)
    endpoint = "/api/where/trip-for-vehicle/#{vehicle_id}.json"
    url = url_builder(endpoint)
    request_endpoint(url)
  end

  def make_request(url)
    begin
      response = self.class.get(url)
      raise OBAError, "Error making request" unless response.code == 200
      response
    rescue HTTParty::ResponseError => e
      raise OBAError, "Error: #{e.response.body}"
    rescue StandardError => e
      raise OBAError, "Network error: #{e.message}"
    end
  end

  def decode_response(response, object_class=nil)
    begin
      json_data = JSON.parse(response.body)
      puts json_data
      # object_class.new(json_data)
    rescue JSON::ParserError => e
      raise OBAError, "Error parsing response: #{e.message}"
    end
  end

  def log(message)
    puts "[LOG] #{message}"
  end

end


oba_sdk = OBASDK.new("TEST")
vehicle_id = "12345"
oba_sdk.get_current_time()
oba_sdk.get_vehicle(vehicle_id)
oba_sdk.get_vehicle_trip(vehicle_id)

