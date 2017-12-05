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
            # @param _err_f [Boolean]
            # @return String
            def format(_data, _err_f)
              raise Idcf::Cli::Error::CliError, 'override'
            end
          end
        end
      end
    end
  end
end
