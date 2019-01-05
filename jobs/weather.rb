require 'net/http'
require_relative '../api_keys'

# you can find CITY_ID here http://bulk.openweathermap.org/sample/city.list.json.gz
CITY_ID = 4487042

# options: metric / imperial
UNITS   = 'imperial'

SCHEDULER.every '20s', :first_in => 0 do |job|

  http = Net::HTTP.new('api.openweathermap.org')
  response = http.request(Net::HTTP::Get.new("/data/2.5/weather?id=#{CITY_ID}&units=#{UNITS}&appid=#{$weather_api_key}"))

  next unless '200'.eql? response.code

  weather_data  = JSON.parse(response.body)
  detailed_info = weather_data['weather'].first
  current_temp  = weather_data['main']['temp'].to_f.round

  send_event('weather', { :temp => "#{current_temp} &deg;#{temperature_units}",
                          :condition => detailed_info['main'],
                          :title => "#{weather_data['name']} Weather",
			  :color => 'metric'.eql?(UNITS) ? color_temperature_metric(current_temp) : color_temperature_imperial(current_temp),
                          :climacon => climacon_class(detailed_info['id'])})
end


def temperature_units
  'metric'.eql?(UNITS) ? 'C' : 'F'
end

def color_temperature_imperial(temp)
  case temp.to_i
  when 85..100
    '#FF3300'
  when 76..84
    '#FF6000'
  when 65..75
    '#FF9D00'
  when 41..64
    '#18A9FF'
  else
    '#0065FF'
  end
end

def color_temperature_metric(temp)
  case temp.to_i
  when 30..100
    '#FF3300'
  when 25..29
    '#FF6000'
  when 19..24
    '#FF9D00'
  when 5..18
    '#18A9FF'
  else
    '#0065FF'
  end
end

# fun times ;) legend: http://openweathermap.org/weather-conditions
def climacon_class(weather_code)
  case weather_code.to_s
  when /800/
    'sun'
  when /80./
    'cloud'
  when /2.*/
    'lightning'
  when /3.*/
    'drizzle'
  when /5.*/
    'rain'
  when /6.*/
    'snow'
  else
    'sun'
  end
end
