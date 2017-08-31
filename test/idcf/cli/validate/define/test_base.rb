require 'test/unit'
require 'idcf/cli/validate/define/base'

module Idcf
  module Cli
    module Validate
      module Define
        # Base
        class TestBase < Test::Unit::TestCase
          data(
            output_none:     {
              output: 'hoge'
            },
            output_upper:    {
              output: 'JSON'
            },
            api_key_none:    {
              secret_key: 'xxx'
            },
            secret_key_none: {
              api_key: 'xxx'
            }
          )

          def test_validate_error(data)
            refute(target_class.new(data).valid?)
          end

          data(
            none:            {},
            require:         {
              output:     'json',
              section:    'default',
              no_ssl:     '',
              no_vssl:    ''
            },
            output_exist1:        {
              output: 'table'
            },
            output_exist2:        {
              output: 'json'
            },
            output_exist3:        {
              output: 'xml'
            },
            output_exist4:        {
              output: 'csv'
            },
            key_exist:            {
              api_key:    'xxx',
              secret_key: 'xxx'
            },
            no_ssl_exist1:        {
              no_ssl: nil
            },
            no_ssl_exist2:        {
              no_ssl: 'hoge'
            },
            no_verify_ssl_exist1: {
              no_vssl: nil
            },
            no_verify_ssl_exist2: {
              no_vssl: 'hoge'
            }
          )

          def test_validate_success(data)
            assert(target_class.new(data).valid?)
          end

          protected

          def target_class
            Idcf::Cli::Validate::Define::Base
          end
        end
      end
    end
  end
end
