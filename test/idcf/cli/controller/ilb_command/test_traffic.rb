require_relative '../test_ilb'

module Idcf
  module Cli
    module Controller
      module IlbCommand
        class TestTraffic < Idcf::Cli::Controller::TestIlb
          self.test_order = :defined

          def setup
            @limit_param = 'sslpolicy_limit'
            @limit_action = 'list_sslpolicies'
            super
          end

          data(
            list: {},
            unit: {
              unit: 'B'
            }
          )

          def test_list_traffics_by_account(data)
            result = do_command(:list_traffics_by_account, data)
            refute(result.empty?)
          end
        end
      end
    end
  end
end
