class ForecastsController < ApplicationController

  before_action :require_address, only: [:index]

  def index
    @address = params[:address]
    fetch_geocoder_info
    weather_forecast
  end

  private

  def fetch_geocoder_info
    @geocoder_result = Geocoder.search(@address).try(:first)
    if @geocoder_result
      @latitude, @longitude = @geocoder_result.coordinates
      @zipcode = @geocoder_result.postal_code
      @location = "#{@geocoder_result.city}, #{@geocoder_result.state}"
    else
      handle_invalid_address
    end
  end

  def weather_forecast
    @weather_forecast = Rails.cache.fetch(@zipcode, expires_in: 30.minutes) { fetch_weather_forecast }
  end

  def fetch_weather_forecast
     Forecast.new(@latitude, @longitude).get_weather_forecast
  end

  def handle_invalid_address
    flash[:error] = "Valid address is required to forecast weather"
    render action: :new
  end

  def require_address
    handle_invalid_address unless params[:address].present?
  end

end
