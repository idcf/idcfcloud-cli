require_relative '../test_ilb'

module Idcf
  module Cli
    module Controller
      module IlbCommand
        # initialize create
        class TestZ < Idcf::Cli::Controller::TestIlb
          self.test_order = :defined

          data(
            delete: {}
          )

          def test_create_loadbalancer(_data)
            lb = find_test_lb
            return output_skip_info('not init lb') if lb.nil?
            befor_lbs = do_command(:list_loadbalancers)
            do_command(:delete_loadbalancer, lb['id'])
            after_lbs = do_command(:list_loadbalancers)
            assert_equal(befor_lbs.size - 1, after_lbs.size)
          end
        end
      end
    end
  end
end
