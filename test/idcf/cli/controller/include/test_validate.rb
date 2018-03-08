require 'test/unit'
require 'idcf/cli/controller/base'

module Idcf
  module Cli
    module Controller
      module Include
        # test validate
        class TestValidate < Test::Unit::TestCase
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
            valid_arr_e1: %w[aaa]
          )

          def test_construction_make_validation_error(data)
            check_data = {
              status:  400,
              message: data,
              data:    []
            }
            assert_equal(@target.send(:make_validation_error, data).keys, check_data.keys)
          end

          data(
            valid_e1:     {
              test: 'aaa'
            },
            valid_e2:     {
              test:  'aaa',
              test2: 'bbb'
            },
            valid_arr_e1: %w[aaa],
            valid_arr_e2: %w[aaa bbb]
          )

          def test_make_validation_error(data)
            assert_equal(@target.send(:make_validation_error, data)[:message].size, data.size)
          end
        end
      end
    end
  end
end
