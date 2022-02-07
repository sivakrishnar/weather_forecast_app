describe ForecastService do

    let(:invalid_latitude) { -104.930420 }
    let(:invalid_longitude) { 39.749434 }

    let(:valid_latitude) { 38.6779591 }
    let(:valid_longitude) { -121.1760583 }
    
    describe 'Fetch forecast service with valid latitude and longitude data' do
        let(:valid_lat_valid_long) { ForecastService.new(valid_latitude, valid_longitude) }
        it "should populate forecast end point data and should not throw any error", :vcr do
            expect(valid_lat_valid_long.fetch_data_api_endpoints).to be_truthy
            expect(valid_lat_valid_long.valid?).to be_truthy
            weather_forecast = valid_lat_valid_long.get_weather_forecast
            expect(weather_forecast).not_to be_empty
            expect(weather_forecast.size).to eq(12)
            expect(valid_lat_valid_long.get_current_temperature).not_to be_empty
        end
    end   

    describe 'Fetch forecast service with valid latitude and longitude data' do
        let(:valid_lat_valid_long) { ForecastService.new(valid_latitude, valid_longitude) }
        it "should populate current temperature and weather forecast data", :vcr do
            weather_forecast = valid_lat_valid_long.get_weather_forecast
            expect(weather_forecast).not_to be_empty
            expect(weather_forecast.size).to eq(12)
            expect(valid_lat_valid_long.get_current_temperature).not_to be_empty
        end
    end
    
    describe 'Fetch forecast service with valid latitude and longitude data' do
        let(:valid_lat_valid_long) { ForecastService.new(valid_latitude, valid_longitude) }
        it "should populate current temperature with numerical data and units info", :vcr do
            current_temperature = valid_lat_valid_long.get_current_temperature
            expect(current_temperature['temperature']).to be_an(Numeric)
            expect(current_temperature['temperatureUnit']).to eq('F')
            expect(current_temperature['name']).not_to be_nil

        end
    end

    describe 'Fetch forecast service with valid latitude and longitude data' do
        let(:valid_lat_valid_long) { ForecastService.new(valid_latitude, valid_longitude) }
        it "should populate weather forecast data with temperature as numerical data and units info", :vcr do
            weather_forecast_data = valid_lat_valid_long.get_weather_forecast
            weather_forecast = weather_forecast_data[0]
            expect(weather_forecast['temperature']).to be_an(Numeric)
            expect(weather_forecast['temperatureUnit']).to eq('F')
            expect(weather_forecast['name']).not_to be_nil
            expect(weather_forecast['shortForecast']).not_to be_nil
            expect(weather_forecast['detailedForecast']).not_to be_nil
        end
    end
    
    ## UNHAPPY TEST CASES
    describe 'Fetch forecast service with nil data' do
        let(:nil_lat_nil_long) { ForecastService.new(nil, nil) }
        it "should not populate forecast end point data and should not throw any error", :vcr do
            expect(nil_lat_nil_long.fetch_data_api_endpoints).to be_falsey
            expect(nil_lat_nil_long.valid?).to be_falsey
            expect(nil_lat_nil_long.get_weather_forecast).to be_empty
        end
    end

    describe 'Fetch forecast service with empty data' do
        let(:empty_lat_empty_long) { ForecastService.new("", "") }
        it "should not populate forecast end point data and should not throw any error", :vcr do
            expect(empty_lat_empty_long.fetch_data_api_endpoints).to be_falsey
            expect(empty_lat_empty_long.valid?).to be_falsey
            expect(empty_lat_empty_long.get_weather_forecast).to be_empty
        end
    end

    describe 'Fetch forecast service with invalid latitude and longitude data' do
        let(:invalid_lat_invalid_long) { ForecastService.new(invalid_latitude, invalid_longitude) }
        it "should not populate forecast end point data and should not throw any error", :vcr do
            expect(invalid_lat_invalid_long.fetch_data_api_endpoints).to be_falsey
            expect(invalid_lat_invalid_long.valid?).to be_falsey
            expect(invalid_lat_invalid_long.get_weather_forecast).to be_empty
        end
    end


end
