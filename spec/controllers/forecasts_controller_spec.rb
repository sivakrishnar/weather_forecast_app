require 'rails_helper'

describe ForecastsController, type: :controller do

   describe "new action" do
     it "Should render new template" do
       get :new
       expect(response).to render_template(:new)
       expect(response).to have_http_status(:ok)
     end
   end

   describe "index action with valid address" do
     it "Should fetch weather data and should render :index template", :vcr do
       get :index, params: {address: "Folsom, CA"}
       expect(response).to have_http_status(:ok)
       expect(response).to render_template(:index)
       expect(assigns(:current_temperature)).to be_present
       expect(assigns(:weather_forecast)).to be_present
     end
   end

   describe "index action with invalid address", :vcr do
    it "Should not fetch weather data and should render :new template with a flash error message", :vcr do
      get :index, params: {address: "Dummy City, CA"}
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:new)
      expect(assigns(:current_temperature)).to be_nil
      expect(assigns(:weather_forecast)).to be_nil
      expect(flash[:error]).to eq 'Valid address is required to forecast weather'
    end
  end

  ## Test cases to verify caching mechanism for weather forecast data
  RSpec.shared_context("with cache", :with_cache) do
    let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
    let(:cache) { Rails.cache }

    before do
      allow(Rails).to receive(:cache).and_return(memory_store)
      Rails.cache.clear
    end

    describe "index action with valid address should show weather forecast data and store that zipcode in cache", :vcr do
      it "Should fetch weather data and store in cache and should render :index template", :vcr do
        get :index, params: {address: "260 Barnhill Dr, Folsom, CA 95630"}
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:index)
        expect(assigns(:from_cache)).to be_falsey
      end
    end

    describe "index action with valid address should show weather forecast data for the zipcode from cache" do
      it "Should fetch weather data and store in cache and should render :index template", :vcr do
        get :index, params: {address: "260 Barnhill Dr, Folsom, CA 95630"}
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:index)
        expect(assigns(:from_cache)).to be_truthy
        expect(cache.exist?("95630")).to be_truthy
      end
    end

  end

end