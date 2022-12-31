class BeermappingApi
  def self.places_in(city)
    city = city.downcase

    Rails.cache.fetch(city, expires_in: 1.weeks) { get_places_in(city) }
  end

  def self.get_places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) && places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.map do |place|
      Place.new(place)
    end
  end

  def self.key
    return nil if Rails.env.test? # testatessa ei apia tarvita, palautetaan nil
    raise 'BEERMAPPING_APIKEY env variable not defined' if ENV['BEERMAPPING_APIKEY'].nil?

    ENV.fetch('BEERMAPPING_APIKEY')
  end

  def self.weather(city)
    return nil if Rails.env.test?

    url = "http://api.weatherstack.com/current?access_key=#{key2}&query="
    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"

    return [] if !response.parsed_response["current"]

    icon = response.parsed_response["current"]["weather_icons"][0]
    temp = response.parsed_response["current"]["temperature"]
    wind = response.parsed_response["current"]["wind_speed"]
    wind_dir = response.parsed_response["current"]["wind_direction"]
    [icon, temp, wind, wind_dir]
  end

  def self.key2
    return nil if Rails.env.test? # testatessa ei apia tarvita, palautetaan nil

    "35da0ab5b5d582da51c51d81c5fa7893"
  end
end
