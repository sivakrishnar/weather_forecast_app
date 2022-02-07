class ForecastsController < ApplicationController

  before_action :require_address, only: [:index]

  def index
    @address = params[:address]
    geocoder_service = GeocoderService.new(@address)
    geocoder_service.populate_geocoder_info
    if geocoder_service.success?
      @location = geocoder_service.location
      @forecast_service = ForecastService.new(geocoder_service.latitude, 
                                              geocoder_service.longitude)
      if @forecast_service.valid?                                              
        set_current_temperature
        @from_cache = Rails.cache.exist? geocoder_service.zipcode
        set_weather_forecast(geocoder_service.zipcode)
      else
        handle_service_down  
      end
    else
      handle_invalid_address
    end  
  end

  private

  def set_current_temperature
    @current_temperature = @forecast_service.get_current_temperature
  end
  
  def set_weather_forecast(zipcode)
    @weather_forecast = Rails.cache.fetch(zipcode, expires_in: 30.minutes) { fetch_weather_forecast }
  end

  def fetch_weather_forecast
     @forecast_service.get_weather_forecast
  end

  def handle_invalid_address
    flash.now[:error] = "Valid address is required to forecast weather"
    render action: :new
  end
  
  def handle_service_down
    flash.now[:error] = "National Weather service API is unreachable, Please try again after sometime"
    render action: :new
  end

  def require_address
    handle_invalid_address unless params[:address].present?
  end

end
