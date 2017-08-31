require_relative '../test_ilb'

module Idcf
  module Cli
    module Controller
      module IlbCommand
        class TestConfig < Idcf::Cli::Controller::TestIlb
          self.test_order = :defined

          data(
            add_one_server:
              {
                algorithm: 'roundrobin',
                frontend_protocol: 'http',
                backend_protocol: 'http',
                connection_timeout: 60,
                healthcheck:
                  {
                    check_interval: 60,
                    healthy_threshold: 10,
                    path: '/',
                    timeout: 60,
                    type: 'http',
                    unhealthy_threshold: 10
                  },
                port: 65_535,
                servers:
                  [
                    {
                      ipaddress: '0.0.1.0',
                      port: 80
                    }
                  ]
              }
          )

          def test_create_config_sccess(data)
            lb = find_test_lb
            return output_skip_info('not test lb') if lb.nil?
            befor_cnt = lb['configs'].size
            do_command(:create_config, lb['id'], data)
            configs = do_command(:configs, lb['id'])
            assert_equal(befor_cnt + 1, configs.size)
          end

          data(
            list_config_cnt: {}
          )

          def test_list_configs_success(_data)
            lb = find_test_lb
            return output_skip_info('not test lb') if lb.nil?
            configs = lb['configs']
            result = do_command(:list_configs, lb['id'])
            assert_equal(configs, result)
          end

          data(
            config: {}
          )

          def test_configs_success(_data)
            lb = find_test_lb
            return output_skip_info('not test lb') if lb.nil?
            configs = lb['configs']
            result = do_command(:configs, lb['id'])
            assert_equal(configs, result)
          end

          data(
            list: {}
          )

          def test_get_config_success(_data)
            lb = find_test_lb
            return output_skip_info('not test lb') if lb.nil?
            config = lb['configs'].last
            result = do_command(:get_config, lb['id'], config['id'])
            assert_equal(config, result)
          end

          data(
            connection_timeout:
              {
                connection_timeout: 40
              },
            port:
              {
                port: 65_500
              }
          )

          def test_patch_config_success(data)
            lb = find_test_lb
            return output_skip_info('not test lb') if lb.nil?
            config = lb['configs'].last
            assert_throw(:done) do
              do_command(:patch_config, lb['id'], config['id'], data)
              throw(:done)
            end
          end

          data(
            del: {}
          )

          def test_delete_config_success(_data)
            lb = find_test_lb
            return output_skip_info('not test lb') if lb.nil?
            config = lb['configs'].last
            do_command(:delete_config, lb['id'], config['id'])
            result = do_command(:get_config, lb['id'], config['id'])
            assert_equal(result.empty?, true)
          end

          data(
            del: {}
          )

          def test_delete_config_all(_data)
            lb = find_test_lb
            return output_skip_info('not test lb') if lb.nil?
            assert_throw(:done) do
              begin
                lb['configs'].reverse_each do |config|
                  do_command(:delete_config, lb['id'], config['id'])
                end
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
