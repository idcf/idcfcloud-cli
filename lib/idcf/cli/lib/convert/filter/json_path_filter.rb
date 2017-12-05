require_relative './base'
require 'jsonpath'
module Idcf
  module Cli
    module Lib
      module Convert
        module Filter
          # filter json path
          class JsonPathFilter < Base
            # filter
            #
            # @param data [Hash]
            # @param condition [String]
            # @return Hash
            def filter(data, condition)
              unless [Array, Hash].include?(data.class)
                cli_error(MSG_NO_DATA) unless condition.empty?
                return data
              end
              path = JsonPath.new(condition)
              path.on(data.to_json)
            rescue => e
              cli_error("[json-path]#{e.message}")
            end
          end
        end
      end
    end
  end
end
