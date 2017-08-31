require 'idcf/cli/validate/define/ilb/base'
require 'idcf/cli/validate/define/test_base'

module Idcf
  module Cli
    module Validate
      module Define
        module Ilb
          # test add server
          class TestBase < Idcf::Cli::Validate::Define::TestBase
            data(
              reason_none1: {},
              reason_none2: {
                region: 'hoge'
              },
              reason_upper: {
                region: 'JP-EAST'
              }
            )

            def test_validate_error(data)
              refute(target_class.new(data).valid?)
            end

            data(
              reason_exist1: {
                region: 'jp-east'
              },
              reason_exist2: {
                region: 'jp-east-2'
              },
              reason_exist3: {
                region: 'jp-west'
              }
            )

            def test_validate_success(data)
              assert(target_class.new(data).valid?)
            end

            protected

            def target_class
              Idcf::Cli::Validate::Define::Ilb::Base
            end
          end
        end
      end
    end
  end
end
