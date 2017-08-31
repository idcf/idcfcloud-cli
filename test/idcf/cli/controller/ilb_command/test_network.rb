require_relative '../test_ilb'

module Idcf
  module Cli
    module Controller
      module IlbCommand
        class TestNetwork < Idcf::Cli::Controller::TestIlb
          self.test_order = :defined

          data(
            default: {}
          )

          def test_list_networks(_data)
            result = do_command(:list_networks)
            refute(result.empty?)
          end

          data(
            default: {}
          )

          def test_networks(_data)
            result = do_command(:networks)
            refute(result.empty?)
          end
        end
      end
    end
  end
end
