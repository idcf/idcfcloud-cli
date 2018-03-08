module Idcf
  module Cli
    module Lib
      module Convert
        module Formatter
          # formatter base
          class Base
            # format
            #
            # @param _data [Hash]
            # @return String
            def format(_data)
              raise Idcf::Cli::Error::CliError, 'override'
            end
          end
        end
      end
    end
  end
end
