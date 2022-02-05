require 'oj'

class Forecast
    include HTTParty
    base_uri  "https://api.weather.gov"

    def initialize(latitude, longitude)
      @latitude = latitude
      @longitude = longitude
      puts "Fetching weather forecast for: #{@latitude},#{@longitude}"
    end

    def get_points
       begin
         response = self.class.get("/points/#{@latitude},#{@longitude}")
         case response.code
           when 200
             return Oj.load(response.body)["properties"]
           when 404
             raise "Weather service down, Please try again after sometime"
           when 500...600
             raise "Unexpected problem with NWS, Please try again after sometime"
         end
       rescue HTTParty::Error, SocketError => e
         raise "Weather service is down, Please try again after sometime"
       end
       {}
    end

    def forecast_url
      @forecast_url ||= self.get_points["forecast"]
    end

    def get_weather_forecast
      begin
        puts self.forecast_url
        response = self.class.get(self.forecast_url)
        p response.body
        p Oj.load(response.body)["properties"]
        return Oj.load(response.body)["properties"]
      rescue HTTParty::Error, SocketError => e
        raise "Weather service is down, Please try later"
      end
      {periods: []}
    end
    


end