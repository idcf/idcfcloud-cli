require_relative '../test_ilb'

module Idcf
  module Cli
    module Controller
      module IlbCommand
        class TestVirtualmachines < Idcf::Cli::Controller::TestIlb
          self.test_order = :defined

          data(
            list: {}
          )

          def test_list_virtualmachines(data)
            result = do_command(:list_virtualmachines, data)
            assert_equal(result.class, Array)
          end

          data(
            list: {}
          )

          def test_list_virtualmachines_name(data)
            vm = do_command(:list_virtualmachines, data).last
            return output_skip_info('virtual machine not found') if vm.nil?
            param = {
              name: vm['name']
            }
            result = do_command(:list_virtualmachines, param)
            selects = result.select do |v|
              v['name'] == vm['name']
            end
            assert_equal(vm, selects.last)
          end
        end
      end
    end
  end
end
