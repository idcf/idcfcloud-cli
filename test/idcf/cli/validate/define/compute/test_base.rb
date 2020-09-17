require 'idcf/cli/validate/define/compute/base'
require 'idcf/cli/validate/define/test_base'

module Idcf
  module Cli
    module Validate
      module Define
        module Compute
          # test compute validator
          class TestBase < Idcf::Cli::Validate::Define::TestBase
            data(
              reason_none:  {
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
              region_none:   {},
              reason_exist1: {
                region: 'jp-east'
              },
              reason_exist2: {
                region: 'jp-east-2'
              },
              reason_exist3: {
                region: 'jp-east-3'
              },
              reason_exist4: {
                region: 'jp-west'
              }
            )

            def test_validate_success(data)
              assert(target_class.new(data).valid?)
            end

            protected

            def target_class
              Idcf::Cli::Validate::Define::Compute::Base
            end
          end
        end
      end
    end
  end
end
