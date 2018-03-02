require 'test/unit'
require 'idcf/cli/conf/const'
require 'idcf/cli/lib/configure'

module Idcf
  module Cli
    module Lib
      # test configure
      class TestConfigure < Test::Unit::TestCase
        @target = nil

        def setup
          @target = Idcf::Cli::Lib::Configure
        end

        def cleanup
          @target = nil
        end

        data(
          exist_key: 'api_key'
        )

        def test_get_user_conf(data)
          result = @target.__send__(:get_user_conf, data)
          refute(result.empty?)
        end

        data(
          not_exist_keyu: 'none'
        )

        def test_raise_get_user_conf(data)
          assert_throw(:done) do
            begin
              @target.__send__(:get_user_conf, data)
              throw(:error)
            rescue StandardError => _e
              throw(:done)
            end
          end
        end

        data(
          user_conf_exist: 'api_key',
          output:          'output',
          hiearchy:        'ilb.v1'
        )

        def test_get_code_conf(data)
          result = @target.__send__(:get_code_conf, data)
          refute(result.empty?)
        end

        data(
          not_exist_keyu: 'none'
        )

        def test_raise_get_code_conf(data)
          assert_throw(:done) do
            begin
              @target.__send__(:get_code_conf, data)
              throw(:error)
            rescue StandardError => _e
              throw(:done)
            end
          end
        end

        data(
          not_option: {
            option: {},
            result: 'default'
          },
          profile:    {
            option: {
              'profile' => 'test'
            },
            result: 'test'
          }
        )

        def test_get_profile(data)
          result = @target.__send__(:get_profile, data[:option])
          assert_equal(result, data[:result])
        end

        data(
          not_option: {
            option: {},
            result: 'default'
          },
          profile:    {
            option: {
              'region' => 'test'
            },
            result: 'test'
          }
        )

        def test_get_region(data)
          result = @target.__send__(:get_region, data[:option], false)
          assert_equal(result, data[:result])
        end

        data(
          default: {},
          region:  {
            'region' => 'test'
          }
        )

        def test_get_region_for_user_conf(data)
          result = @target.__send__(:get_region, data, true)
          refute(result.empty?)
        end
      end
    end
  end
end
