require_relative '../test_ilb'

module Idcf
  module Cli
    module Controller
      module IlbCommand
        class TestLog < Idcf::Cli::Controller::TestIlb
          self.test_order = :defined

          data(
            default: {}
          )

          def test_list_logs(data)
            result = do_command(:list_logs, data)
            refute(result.empty?)
          end

          data(
            default: {}
          )

          def test_logs(data)
            result = do_command(:logs, data)
            refute(result.empty?)
          end
        end
      end
    end
  end
end
