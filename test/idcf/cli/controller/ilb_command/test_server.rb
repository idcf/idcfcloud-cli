require_relative '../test_ilb'

module Idcf
  module Cli
    module Controller
      module IlbCommand
        class TestServer < Idcf::Cli::Controller::TestIlb
          self.test_order = :defined

          data(
            add:
              {
                ipaddress: '0.5.0.0',
                port: 80
              }
          )

          def test_add_server(data)
            lb = find_test_lb
            return output_skip_info('not test lb') if lb.nil?
            config = lb['configs'].last
            befor_cnt = config['servers'].size
            do_command(:add_server, lb['id'], config['id'], data)
            after_cnt = do_command(:list_servers, lb['id'], config['id']).size
            assert_equal(befor_cnt + 1, after_cnt)
          end

          data(
            servers: {}
          )

          def test_list_servers(_data)
            lb = find_test_lb
            return output_skip_info('not test lb') if lb.nil?
            config = lb['configs'].last
            result = do_command(:list_servers, lb['id'], config['id'])
            refute(result.empty?)
          end

          data(
            lb_none:
              {
                lb: false,
                conf: true,
                data: {
                  ipaddress: '0.5.1.0',
                  port: 80
                }
              },
            conf_none:
              {
                lb: true,
                conf: false,
                data: {
                  ipaddress: '0.5.1.1',
                  port: 80
                }
              },
            data_none:
              {
                lb: true,
                conf: true,
                data: {}
              },
            data_str:
              {
                lb: true,
                conf: true,
                data: {
                  'ipaddress' => '0.5.1.2',
                  'port' => 80
                }
              },
            data_port_str:
              {
                lb: true,
                conf: true,
                data: {
                  ipaddress: '0.5.1.3',
                  port: '80'
                }
              },
            data_port_none:
              {
                lb: true,
                conf: true,
                data: {
                  ipaddress: '0.5.1.4'
                }
              },
            data_addr_none:
              {
                lb: true,
                conf: true,
                data: {
                  port: 80
                }
              }
          )

          def test_add_server_error(data)
            lb = find_test_lb
            return output_skip_info('not test lb') if lb.nil?
            config = lb['configs'].last

            lb_id = data[:lb] ? lb['id'] : nil
            conf_id = data[:conf] ? config['id'] : nil
            assert_throw(:done) do
              begin
                do_command(:add_server, lb_id, conf_id, data[:data])
              rescue
                throw(:done)
              end
            end
          end

          data(
            delete: {}
          )

          def test_delete_server(_data)
            lb = find_test_lb
            return output_skip_info('not test lb') if lb.nil?
            config = lb['configs'].last
            befor_cnt = config['servers'].size
            do_command(:delete_server, lb['id'], config['id'], config['servers'].last['id'])
            after_cnt = do_command(:list_servers, lb['id'], config['id']).size
            assert_equal(befor_cnt - 1, after_cnt)
          end

          data(
            delete: {}
          )

          def test_all_delete_server(_data)
            lb = find_test_lb
            return output_skip_info('not test lb') if lb.nil?
            config = lb['configs'].last
            assert_throw(:done) do
              begin
                config['servers'].reverse_each do |v|
                  do_command(:delete_server, lb['id'], config['id'], v['id'])
                end
              rescue
                throw(:done)
              end
            end
          end

          data(
            check: {}
          )

          def test_all_delete_server_count(_data)
            lb = find_test_lb
            return output_skip_info('not test lb') if lb.nil?
            config = lb['configs'].last
            cnt = do_command(:list_servers, lb['id'], config['id']).size
            assert_equal(cnt, 1)
          end
        end
      end
    end
  end
end
