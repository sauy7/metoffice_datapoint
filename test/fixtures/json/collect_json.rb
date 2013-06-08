# This file is used to collect a variety of test data from the Met Office DataPoint API.

require 'restclient'
require 'date'
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
