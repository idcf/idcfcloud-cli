require 'test/unit'
require 'idcf/cli/index'
require 'idcf/cli/conf/const'
require 'thor'

module Idcf
  module Cli
    module Extend
      # test configure
      class TestConfigure < Test::Unit::TestCase
        @target = nil

        def setup
          Idcf::Cli::Index.init({})
          @target = Idcf::Cli::Index.new
        end

        def cleanup
          @target = nil
        end

        data(
          local:  {
            options: {
              global: false
            },
            path:    Idcf::Cli::Conf::Const::USER_CONF_PATH
          },
          global: {
            options: {
              global: true
            },
            path:    Idcf::Cli::Conf::Const::USER_CONF_GLOBAL
          }
        )

        def test_configure_path(data)
          path = File.expand_path(data[:path])
          result = @target.send(:configure_path, data[:options])
          assert_equal(result, path)
        end
      end
    end
  end
end
