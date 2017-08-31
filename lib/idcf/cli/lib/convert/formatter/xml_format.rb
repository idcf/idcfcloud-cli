require_relative './base'
require 'builder/xmlmarkup'
require 'active_support'
require 'active_support/core_ext'

module Idcf
  module Cli
    module Lib
      module Convert
        module Formatter
          # xml formatter
          class XmlFormat < Base
            def format(data, _err_f)
              data.to_xml
            end
          end
        end
      end
    end
  end
end
