require_relative '../test_ilb'

module Idcf
  module Cli
    module Controller
      module IlbCommand
        class TestServerExtend < Idcf::Cli::Controller::TestIlb
          self.test_order = :defined

          data(
            add:
              {
                protocol: 'http',
                port: 65_500,
                server:
                  {
                    ipaddress: '0.6.1.0',
                    port: 80
                  }
              }
          )

          def test_add_serve_for_protocol_success(data)
            lb = find_test_lb
            return output_skip_info('not test lb') if lb.nil?
            configs = lb['configs'].select do |v|
              data[:protocol] == v['frontend_protocol'] &&
                data[:port] == v['port']
            end
            return output_skip_info('not target configure') if configs.empty?
            config = configs.first
            befor_cnt = config['servers'].size
            cmd = :add_server_for_protocol
            args = [
              lb['id'],
              config['frontend_protocol'],
              config['port']
            ]
            do_command(cmd, *args, data[:server])
            after_cnt = do_command(:list_servers, lb['id'], config['id']).size
            assert_equal(befor_cnt + 1, after_cnt)
          end

          data(
            delete:
              {
                protocol: 'http',
                port: 65_500,
                server:
                  {
                    ipaddress: '0.6.1.0',
                    port: 80
                  }
              }
          )

          def test_delete_serve_for_protocol_success(data)
            lb = find_test_lb
            return output_skip_info('not test lb') if lb.nil?
            configs = lb['configs'].select do |v|
              data[:protocol] == v['frontend_protocol'] &&
                data[:port] == v['port']
            end
            return output_skip_info('not target configure') if configs.empty?
            config = configs.first
            befor_cnt = config['servers'].size
            cmd = :delete_server_for_protocol
            args = [
              lb['id'],
              config['frontend_protocol'],
              config['port']
            ]
            do_command(cmd, *args, data[:server])
            after_cnt = do_command(:list_servers, lb['id'], config['id']).size
            assert_equal(befor_cnt - 1, after_cnt)
          end
        end
      end
    end
  end
end
