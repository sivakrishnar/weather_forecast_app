# WeatherForecastApp

This is a Ruby on Rails app developed using [National Weather Service](https://api.weather.gov) to get weather data for given address. 

# Gems Used:
geocoder: Provides geocoding solution
bootstrap: CSS
oj: Faster JSON parsing
httparty: Making API call to external end points
rspec-rails: rspec for testing
webmock: Web mock to stub requests during testing
vcr: Used to make an actual API all and test result which can be played later for testing

## Cache:

Caching mechanism has been used to store weather forecast data for 30 minutes. Uses rails file_store based cache for developmental purposes.

## RSpec Test Cases

Test cases have been implemented using Rspec

## Notes & caveats

* App was developed using Ruby on Rails template in GitPod cloud development environment.
* There is a stateless app so no database is required.
* Developed using ruby 2.7.3 with rails 6

## Contact

* siva.rorm9@gmail.com