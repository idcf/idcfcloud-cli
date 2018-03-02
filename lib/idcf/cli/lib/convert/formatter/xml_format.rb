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
            def format(data)
              data.to_xml(dasherize: false)
            end
          end
        end
      end
    end
  end
end
