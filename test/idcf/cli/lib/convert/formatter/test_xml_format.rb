require_relative './test_base'
require 'idcf/cli/lib/convert/formatter/xml_format'

module Idcf
  module Cli
    module Lib
      module Convert
        module Formatter
          class TestXmlFormat < TestBase
            @target = nil

            def setup
              @target = XmlFormat.new
            end

            def cleanup
              @target = nil
            end

            data(err: ERROR_NO_DATA_ARRAY)

            def test_format_error_msg(data)
              str = <<"EOT"
<?xml version="1.0" encoding="UTF-8"?>
<hash>
  <status type="integer">400</status>
  <message type="array">
    <message>msg</message>
    <message>msg2</message>
  </message>
  <data type="array"/>
</hash>
EOT
              assert_equal(@target.format(data, true).strip, str.strip)
            end
          end
        end
      end
    end
  end
end
