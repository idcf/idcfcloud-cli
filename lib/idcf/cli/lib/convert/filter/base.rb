require 'active_support'
require 'active_support/core_ext'
module Idcf
  module Cli
    module Lib
      module Convert
        module Filter
          # filter base
          class Base
            attr_accessor :options

            MSG_NO_DATA = 'No data is extracted.'.freeze

            def initialize(table_flag: false)
              @options = {
                table_flag: table_flag
              }
            end

            # filter
            #
            # @param _data [Hash]
            # @param _condition [String]
            # @return Hash
            # @raise
            def filter(_data, _condition)
              raise Idcf::Cli::Error::CliError, 'override'
            end

            protected

            def cli_error(msg)
              raise Idcf::Cli::Error::CliError, msg
            end
          end
        end
      end
    end
  end
end
