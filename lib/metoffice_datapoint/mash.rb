# -*- encoding: utf-8 -*-
require 'hashie/mash'
require 'oj'

module MetofficeDatapoint
  # Public: Provides pseudo-objects (a Hashie::Mash) representing the responses from the Met Office DataPoint API.
  #
  # Warning: The conversion process is slow for large objects. It is not recommended to use this class on responses
  #   from requests to the API returning data for all locations.
  class Mash < ::Hashie::Mash
    protected

    # Protected: Convert keys to a more rubyesque style (underscroce, lowercase). Excludes keys with specific meanings.
    #   Overloads the the convert_key Mash method.
    #
    # key - String, possibly containing CamelCase words and/or dash-es
    #
    # Examples:
    #   convert_key("CamelCase") => camel_case
    #   convert_key("dash-es") => dash_es
    #
    # Returns String based on lowercase letters and an underscore for separation.
    def convert_key(key)
      case key
        when '$'
          'text'
        when 'D', 'Dm', 'F', 'FDm', 'FNm', 'G', 'Gm', 'Gn', 'H', 'Hm', 'Hn', 'Nm', 'P', 'Pp', 'PPd', 'PPn', 'S', 'T', 'U', 'V', 'W'
          key
        else
          key.to_s.strip.
              gsub(' ', '_').
              gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
              gsub(/([a-z\d])([A-Z])/,'\1_\2').
              tr("-", "_").
              squeeze("_").
              downcase
      end
    end

    # Protected: Unlike its parent Mash, this Mash will convert other Hashie::Hash values to a Mash when assigning
    #   instead of respecting the existing subclass. Also converts Strings parseable by Date(Time).parse to Date(Time)
    #   objects.
    #   Overloads the the convert_value Mash method.
    #
    # val - Object to be converted.
    #
    # Examples:
    #   convert_value(#<Array ...>) => recursively calls itself to convert values in Array
    #   convert_value(#<::Hash ...>) => Mash.new(#<::Hash ...>)
    #   convert_value("my string") => "my string"
    #   convert_value("2013-06-10T12:00:00Z") => #<DateTime: 2013-06-10T12:00:00Z ...>
    #   convert_value("2013-06-10Z") => #<Date: 2013-06-10 ...>
    #
    # Returns Objects of different types, depending on the original val passed in.
    def convert_value(val, duping=false) #:nodoc:
      case val
        when self.class
          val.dup
        when ::Hash
          val = val.dup if duping
          self.class.new(val)
        when Array
          val.collect{ |e| convert_value(e) }
        else
          if val.class == String
            begin
              datetime_regexp = /^[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}T[[:digit:]]{2}:[[:digit:]]{2}:[[:digit:]]{2}Z$/
              return DateTime.parse(val) if datetime_regexp.match(val)
              date_regexp = /^[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}Z$/
              return Date.parse(val) if date_regexp.match(val)
            rescue
              # no Date or DateTime found, keep calm and carry on
            end
            val
          else
            val
          end
      end
    end
  end
end