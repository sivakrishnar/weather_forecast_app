class GeocoderService 
  
    attr_reader :address, :latitude, :longitude, :zipcode, :location
    
    def initialize(address)
      @address = address
    end

    # Geocoder service to get latitude, longitude based on address
    def populate_geocoder_info
      geocoder_result = Geocoder.search(@address)
      geocoder_result = geocoder_result.find{|data| data.postal_code.present?} if geocoder_result
      if geocoder_result
        @latitude, @longitude = geocoder_result.coordinates
        @zipcode = geocoder_result.postal_code
        @location = geocoder_result.address
        return true
      end
      false
    end
    
end