require_relative './test_base'
require 'idcf/cli/lib/convert/formatter/json_format'

module Idcf
  module Cli
    module Lib
      module Convert
        module Formatter
          class TestJsonFormat < TestBase
            @target = nil

            def setup
              @target = JsonFormat.new
            end

            def cleanup
              @target = nil
            end

            data(err_no_data: ERROR_NO_DATA_ARRAY)

            def test_format_error_msg(data)
              str = <<"EOT"
{"status":400,"message":["msg","msg2"],"data":[]}
EOT
              assert_equal(@target.format(data, true), str.strip)
            end

            data(err_no_data: ERROR_NO_DATA_HASH)

            def test_format_error_msg_hash(data)
              str = <<"EOT"
{"status":400,"message":["msg","msg2"],"data":{}}
EOT
              assert_equal(@target.format(data, true), str.strip)
            end

            data(err: FORMAT_VALIDATE_ERROR)

            def test_format_validate_error_msg(data)
              str = <<"EOT"
{"status":400,"message":{"v1":["v1 error"],"v2":["v2 error"]},"data":[]}
EOT
              assert_equal(@target.format(data, true), str.strip)
            end

            data(array: FORMAT_SUCCESS_NONE_ARRAY)

            def test_format_success_none(data)
              str = <<"EOT"
{"status":200,"message":[],"data":[]}
EOT
              assert_equal(@target.format(data, false), str.strip)
            end

            data(hash: FORMAT_SUCCESS_NONE_HASH)

            def test_format_success_none_hash(data)
              str = <<"EOT"
{"status":200,"message":[],"data":{}}
EOT
              assert_equal(@target.format(data, false), str.strip)
            end

            data(num: FORMAT_SUCCESS_FLAT_ARRAY_NUM)

            def test_format_success_flat_array_num(data)
              str = <<"EOT"
{"status":200,"message":[],"data":[10,20,30,40]}
EOT
              assert_equal(@target.format(data, false), str.strip)
            end

            data(str: FORMAT_SUCCESS_FLAT_ARRAY_STR)

            def test_format_success_flat_array_str(data)
              str = <<"EOT"
{"status":200,"message":[],"data":["10","20","30","40"]}
EOT
              assert_equal(@target.format(data, false), str.strip)
            end

            data(one: FORMAT_SUCCESS_ONE_DATA)

            def test_format_success_one_data(data)
              str = <<"EOT"
{"status":200,"message":[],"data":[{"id":"1-0-1","txt":"1-0-1 sample","conf":{"id":"1-1-1","txt":"1-1 sample"},"list":[{"id":"1-2-1","txt":"2-1 sample"},{"id":"1-2-2","txt":"2-2 sample"}]}]}
EOT
              assert_equal(@target.format(data, false), str.strip)
            end
          end
        end
      end
    end
  end
end
