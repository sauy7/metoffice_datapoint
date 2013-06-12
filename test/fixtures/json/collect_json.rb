# This file is used to collect a variety of test data from the Met Office DataPoint API.

require 'restclient'
require_relative '../../api_key'

base_uri = 'http://datapoint.metoffice.gov.uk/public/data/'

q_string = "?key=#{API_KEY}"
daily = '&res=daily'
three_hourly = '&res=3hourly'
hourly = "&res=hourly"

# The following should be adjusted
timestep = "2013-06-08T00:00:00Z"
timestep_filename = timestep.gsub("-", '_').gsub(':', '_')



##########################
# Location Forecast Data #
##########################

f_sitelist = 'val/wxfcs/all/json/sitelist'
f_capabilities = 'val/wxfcs/all/json/capabilities'
f_all = 'val/wxfcs/all/json/all'
f_id = "val/wxfcs/all/json/3094"

File.open('f_sitelist.json', 'w') { |f|
  uri = "#{base_uri}#{f_sitelist}#{q_string}"
  puts uri
  RestClient.get(uri) { |response, request, headers|
    f.write(response.to_str)
  }
}

File.open('f_capabilities_daily.json', 'w') { |f|
  uri = "#{base_uri}#{f_capabilities}#{q_string}#{daily}"
  puts uri
  RestClient.get(uri) { |response, request, headers|
    f.write(response.to_str)
  }
}

File.open('f_capabilities_3hourly.json', 'w') { |f|
  uri = "#{base_uri}#{f_capabilities}#{q_string}#{three_hourly}"
  puts uri
  RestClient.get(uri) { |response, request, headers|
    f.write(response.to_str)
  }
}

File.open('f_all_daily.json', 'w') { |f|
  uri = "#{base_uri}#{f_all}#{q_string}#{daily}"
  puts uri
  RestClient.get(uri) { |response, request, headers|
    f.write(response.to_str)
  }
}

File.open("f_all_daily_#{timestep_filename}.json", 'w') { |f|
  uri = "#{base_uri}#{f_all}#{q_string}#{daily}&time=#{timestep}"
  puts uri
  RestClient.get(uri) { |response, request, headers|
    f.write(response.to_str)
  }
}

File.open('f_all_3hourly.json', 'w') { |f|
  uri = "#{base_uri}#{f_all}#{q_string}#{three_hourly}"
  puts uri
  RestClient.get(uri) { |response, request, headers|
    f.write(response.to_str)
  }
}

File.open("f_all_3hourly_#{timestep_filename}.json", 'w') { |f|
  uri = "#{base_uri}#{f_all}#{q_string}#{three_hourly}&time=#{timestep}"
  puts uri
  RestClient.get(uri) { |response, request, headers|
    f.write(response.to_str)
  }
}

File.open('f_3094_daily.json', 'w') { |f|
  uri = "#{base_uri}#{f_id}#{q_string}#{daily}"
  puts uri
  RestClient.get(uri) { |response, request, headers|
    f.write(response.to_str)
  }
}

File.open('f_3094_3hourly.json', 'w') { |f|
  uri = "#{base_uri}#{f_id}#{q_string}#{three_hourly}"
  puts uri
  RestClient.get(uri) { |response, request, headers|
    f.write(response.to_str)
  }
}



#############################
# Location Observation Data #
#############################

o_sitelist = 'val/wxobs/all/json/sitelist'
o_capabilities = 'val/wxobs/all/json/capabilities'
o_all = 'val/wxobs/all/json/all'
o_id = "val/wxobs/all/json/3002"

File.open('o_sitelist.json', 'w') { |f|
  uri = "#{base_uri}#{o_sitelist}#{q_string}"
  puts uri
  RestClient.get(uri) { |response, request, headers|
    f.write(response.to_str)
  }
}

File.open('o_capabilities_hourly.json', 'w') { |f|
  uri = "#{base_uri}#{o_capabilities}#{q_string}#{hourly}"
  puts uri
  RestClient.get(uri) { |response, request, headers|
    f.write(response.to_str)
  }
}

File.open('o_all_hourly.json', 'w') { |f|
  uri = "#{base_uri}#{o_all}#{q_string}#{hourly}"
  puts uri
  RestClient.get(uri) { |response, request, headers|
    f.write(response.to_str)
  }
}

File.open('o_3002_hourly.json', 'w') { |f|
  uri = "#{base_uri}#{o_id}#{q_string}#{hourly}"
  puts uri
  RestClient.get(uri) { |response, request, headers|
    f.write(response.to_str)
  }
}



#############
# Text Data #
#############

endpoints = {
    'o_ukextremes_capabilities'   => 'txt/wxobs/ukextremes/json/capabilities',
    'o_ukextremes_latest'         => 'txt/wxobs/ukextremes/json/latest',
    'f_nationalpark_sitelist'     => 'txt/wxfcs/nationalpark/json/sitelist',
    'f_nationalpark_capabilities' => 'txt/wxfcs/nationalpark/json/capabilities',
    'f_nationalpark_all' => 'txt/wxfcs/nationalpark/json/all',
    'f_nationalpark_600' => 'txt/wxfcs/nationalpark/json/600',
    'f_regional_sitelist' => 'txt/wxfcs/regionalforecast/json/sitelist',
    'f_regional_capabilities' => 'txt/wxfcs/regionalforecast/json/capabilities',
    'f_regional_500' => 'txt/wxfcs/regionalforecast/json/500',
    'f_mountainarea_sitelist' => 'txt/wxfcs/mountainarea/json/sitelist',
    'f_mountainarea_capabilities' => 'txt/wxfcs/mountainarea/json/capabilities',
    'f_mountainarea_100' => 'txt/wxfcs/mountainarea/json/100'
}

endpoints.each do |file, path|
  File.open("#{file}.json", 'w') { |f|
    uri = "#{base_uri}#{path}#{q_string}"
    puts uri
    RestClient.get(uri) { |response, request, headers|
      f.write(response.to_str)
    }
  }
end



################
# Map Overlays #
################

endpoint = 'http://datapoint.metoffice.gov.uk/public/data/layer/wxfcs/all/json/capabilities'

File.open("f_layer.json", 'w') { |f|
  uri = "#{endpoint}#{q_string}"
  puts uri
  RestClient.get(uri) { |response, request, headers|
    f.write(response.to_str)
  }
}

endpoint = 'http://datapoint.metoffice.gov.uk/public/data/layer/wxobs/all/json/capabilities'

File.open("o_layer.json", 'w') { |f|
  uri = "#{endpoint}#{q_string}"
  puts uri
  RestClient.get(uri) { |response, request, headers|
    f.write(response.to_str)
  }
}



###################
# Standalone Maps #
###################

endpoint = 'http://datapoint.metoffice.gov.uk/public/data/image/wxfcs/surfacepressure/json/capabilities'

File.open("standalone.json", 'w') { |f|
  uri = "#{endpoint}#{q_string}"
  puts uri
  RestClient.get(uri) { |response, request, headers|
    f.write(response.to_str)
  }
}