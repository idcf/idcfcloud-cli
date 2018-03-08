require 'test/unit'
require 'idcf/cli/controller/base'

module Idcf
  module Cli
    module Controller
      module Include
        # test command
        class TestCommand < Test::Unit::TestCase
          @target = nil

          def setup
            @target = target_class_name.new
          end

          def cleanup
            @target = nil
          end

          def target_class_name
            Idcf::Cli::Controller::Base
          end

          data(
            none:
              {
                before: [],
                after:  []
              },
            str_only:
              {
                before: %w[aaa],
                after:  %w[aaa]
              },
            json_only:
              {
                before:
                  [
                    '{}'
                  ],
                after:
                  [
                    {}
                  ]
              },
            json_only_empty:
              {
                before:
                  [
                    '{"test": "aaa"}'
                  ],
                after:
                  [
                    { 'test' => 'aaa' }
                  ]
              },
            mix:
              {
                before:
                  [
                    'aaa',
                    '{"test": "aaa"}'
                  ],
                after:
                  [
                    'aaa',
                    { 'test' => 'aaa' }
                  ]
              }
          )

          def test_convert_arg_json(data)
            result = @target.__send__(:convert_arg_json, *data[:before])
            assert_equal(result, data[:after])
          end
        end
      end
    end
  end
end
