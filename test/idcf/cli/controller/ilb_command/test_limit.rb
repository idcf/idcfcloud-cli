require_relative '../test_ilb'

module Idcf
  module Cli
    module Controller
      module IlbCommand
        class TestLimit < Idcf::Cli::Controller::TestIlb
          self.test_order = :defined

          data(
            limit: {}
          )

          def test_get_limit(_data)
            result = do_command(:get_limit)
            refute(result.empty?)
          end

          data(
            limit: {}
          )

          def test_limit(_data)
            result = do_command(:limit)
            refute(result.empty?)
          end
        end
      end
    end
  end
end
