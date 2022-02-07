require 'oj'

class ForecastService
    include HTTParty
    base_uri  "https://api.weather.gov"

    def initialize(latitude, longitude)
      @latitude = latitude
      @longitude = longitude
      self.fetch_data_api_endpoints
    end

    # This will fetch required API end points from NWS /points API
    def fetch_data_api_endpoints
       begin
         response = self.class.get("/points/#{@latitude},#{@longitude}")
         if response.code == 200
             points = Oj.load(response.body)["properties"]
             if points
               @forecast_url = points["forecast"]
               @current_weather_url = points["forecastHourly"]
             end
         end
       rescue HTTParty::Error, SocketError => e
         puts "Weather service is down, Please try again after sometime"
       end
    end

    def get_weather_forecast
      begin
        response = self.class.get(@forecast_url)
        properties = Oj.load(response.body)["properties"]
        if properties and properties.has_key? "periods"
          return properties["periods"][1..12]
        end
      rescue HTTParty::Error, SocketError => e
        puts "Weather service is down, Please try later"
      end
      []
    end
    
    def get_current_temperature
      begin
        response = self.class.get(@current_weather_url)
        properties = Oj.load(response.body)["properties"]
        return properties["periods"][0]
      rescue HTTParty::Error, SocketError => e
        puts "Weather service is down, Please try later"
      end
      []
    end

    def valid?
      @forecast_url.present? and @current_weather_url.present?
    end

end