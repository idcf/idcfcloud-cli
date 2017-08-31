require_relative '../test_ilb'

module Idcf
  module Cli
    module Controller
      module IlbCommand
        class TestFwgroup < Idcf::Cli::Controller::TestIlb
          self.test_order = :defined

          def setup
            @limit_param = 'fwgroup_limit'
            @limit_action = 'list_fwgroups'
            super
          end

          data(
            add:
              {
                name: 'test-fwgroup-mix-1',
                allow: %w(0.3.5.1/32),
                drop: %w(0.3.5.2/32)
              }
          )

          def test_create_fwgroup_sccess(data)
            return output_skip_info('out limit') if limit?
            befor_group = do_command(:list_fwgroups)
            data[:name] = make_unique_name(data[:name], befor_group, 'name')
            do_command(:create_fwgroup, data)
            result_cnt = do_command(:list_fwgroups).size
            assert_equal(befor_group.size + 1, result_cnt)
          end

          data(
            get_fw: {}
          )

          def test_get_fwgroup(_data)
            fw = do_command(:list_fwgroups).last
            result = do_command(:get_fwgroup, fw['id'])
            check = pickup_same_item(fw, result)
            assert_equal(fw, check)
          end

          data(
            del_fw: {}
          )

          def test_delete_fwgroup(_data)
            return output_skip_info('out limit') if limit?
            fw = do_command(:list_fwgroups).last
            do_command(:delete_fwgroup, fw['id'])
            result = do_command(:get_fwgroup, fw['id'])
            assert(result.empty?)
          end

          data(
            allow_one:
              {
                name: 'test-fwgroup-allow-1',
                allow: %w(0.3.1.1/32)
              },
            allow_two:
              {
                name: 'test-fwgroup-allow-2',
                allow: %w(0.3.2.1/32 0.3.2.2/32)
              },
            drop_one:
              {
                name: 'test-fwgroup-drop-1',
                drop: %w(0.3.3.1/32)
              },
            drop_two:
              {
                name: 'test-fwgroup-drop-2',
                drop: %w(0.3.4.1/32 0.3.4.2/32)
              }
          )

          def test_create_fwgroup_pattern_sccess(data)
            return output_skip_info('out limit') if limit?
            befor_group = do_command(:list_fwgroups)
            data[:name] = make_unique_name(data[:name], befor_group, 'name')
            fw = do_command(:create_fwgroup, data)
            result_cnt = do_command(:list_fwgroups).size
            do_command(:delete_fwgroup, fw['id'])
            assert_equal(befor_group.size + 1, result_cnt)
          end

          data(
            drop_empty:
              {
                name: 'test-fwgroup-allow-1',
                allow: %w(0.3.1.1/32),
                drop: %w()
              },
            allow_empty:
              {
                name: 'test-fwgroup-drop-1',
                allow: %w(),
                drop: %w(0.3.3.1/32)
              },
            empty:
              {
                name: 'test-fwgroup-drop-2'
              }
          )

          def test_create_fwgroup_error(data)
            return output_skip_info('out limit') if limit?
            fws = do_command(:list_fwgroups)
            data[:name] = make_unique_name(data[:name], fws, 'name')
            assert_throw(:done) do
              begin
                do_command(:create_fwgroup, data)
              rescue
                throw(:done)
              end
            end
          end
        end
      end
    end
  end
end
