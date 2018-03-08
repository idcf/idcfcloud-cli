require 'idcf/cli/conf/const'
require 'uri'
module Idcf
  module Cli
    module Controller
      module Include
        # command
        module Command
          include Comparable

          protected

          # convert arg json
          # json string to Hash
          #
          # @param args [Array]
          # @return Array
          def convert_arg_json(*args)
            result = []
            args.each do |v|
              begin
                result << JSON.parse(v, symbolize_names: false)
              rescue StandardError => _e
                result << v
              end
            end
            result
          end
        end
      end
    end
  end
end
