require 'test/unit'
require 'idcf/cli/controller/base'

module Idcf
  module Cli
    module Controller
      module Include
        # test client
        class TestClient < Test::Unit::TestCase
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
            vertify:    {
              option: {},
              result: {
                verify: true
              }
            },
            no_vertify: {
              option: {
                no_vssl: true
              },
              result: {
                verify: false
              }
            },
            no_vertify2: {
              option: {
                no_vssl: false
              },
              result: {
                verify: false
              }
            }
          )

          def test_make_ssl_option(data)
            result = @target.__send__(:make_ssl_option, data[:option])
            assert_equal(result, data[:result])
          end
        end
      end
    end
  end
end
