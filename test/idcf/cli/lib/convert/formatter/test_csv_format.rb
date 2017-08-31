require_relative './test_base'
require 'idcf/cli/lib/convert/formatter/csv_format'

module Idcf
  module Cli
    module Lib
      module Convert
        module Formatter
          # test csv format
          class TestCsvFormat < TestBase
            @target = nil

            def setup
              @target = CsvFormat.new
            end

            def cleanup
              @target = nil
            end

            data(
              err_no_data_array: ERROR_NO_DATA_ARRAY,
              err_no_data_hash: ERROR_NO_DATA_HASH,
              err_exist_data: ERROR_EXIST_DATA
            )

            def test_format_error_msg(data)
              str = <<"EOT"
status,message
400,"msg
msg2"
EOT
              assert_equal(@target.format(data, true), str.strip)
            end

            data(err: FORMAT_VALIDATE_ERROR)

            def test_format_validate_error_msg(data)
              str = <<"EOT"
status,message
400,"v1:v1 error
v2:v2 error"
EOT
              assert_equal(@target.format(data, true), str.strip)
            end

            data(
              array: FORMAT_SUCCESS_NONE_ARRAY,
              hash: FORMAT_SUCCESS_NONE_HASH
            )

            def test_format_success_none(data)
              assert_equal(@target.format(data[:data], false), '')
            end

            data(
              num: FORMAT_SUCCESS_FLAT_ARRAY_NUM,
              str: FORMAT_SUCCESS_FLAT_ARRAY_STR
            )

            def test_format_success_flat_array(data)
              str = <<"EOT"
0
10
20
30
40
EOT
              assert_equal(@target.format(data[:data], false), str.strip)
            end

            data(one: FORMAT_SUCCESS_ONE_DATA)

            def test_format_success_one_data(data)
              str = <<"EOT"
id,txt
1-0-1,1-0-1 sample
EOT
              assert_equal(@target.format(data[:data], false), str.strip)
            end

            data(miulti: FORMAT_SUCCESS_MULTI_DATA)

            def test_format_success_multi_data(data)
              str = <<"EOT"
id,txt
1-0-1,1-0-1 sample
2-0-1,2-0-1 sample
EOT
              assert_equal(@target.format(data[:data], false), str.strip)
            end
          end
        end
      end
    end
  end
end
