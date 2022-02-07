class GeocoderService 
  
    attr_reader :address, :latitude, :longitude, :zipcode, :location
    
    def initialize(address)
      @address = address
    end

    # Geocoder service to get latitude, longitude based on address
    def populate_geocoder_info
      geocoder_result = Geocoder.search(@address).try(:first)
      p geocoder_result
      if geocoder_result
        @latitude, @longitude = geocoder_result.coordinates
        @zipcode = geocoder_result.postal_code
        @location = "#{geocoder_result.city}, #{geocoder_result.state} #{@zipcode}"  
      end
    end

    def success?
      self.longitude.present? and self.latitude.present?
    end
    
end