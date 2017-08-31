require 'active_support/core_ext/string/inflections'
require 'idcf/cli/lib/convert/formatter/xml_format'
require 'idcf/cli/lib/convert/formatter/json_format'
require 'idcf/cli/lib/convert/formatter/csv_format'
require 'idcf/cli/lib/convert/formatter/table_format'

module Idcf
  module Cli
    module Lib
      module Convert
        # format helper
        class Helper
          # data convert
          #
          # @param data [Hash]
          # @param err_f [Boolean]
          # @param f [String] format
          # @return String
          def format(data, err_f, f)
            base_name = 'Idcf::Cli::Lib::Convert::Formatter'
            cl = "#{base_name}::#{f.capitalize}Format"
            cl.constantize.new.format(data, err_f)
          end
        end
      end
    end
  end
end
