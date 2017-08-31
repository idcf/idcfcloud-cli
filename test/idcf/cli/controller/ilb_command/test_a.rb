require_relative '../test_ilb'
require 'json'

module Idcf
  module Cli
    module Controller
      module IlbCommand
        # initialize create
        class TestA < Idcf::Cli::Controller::TestIlb
          self.test_order = :defined

          def setup
            @limit_param = 'loadbalancer_limit'
            @limit_action = 'list_loadbalancers'
            super
          end

          data(
            add:
              {
                name: TEST_NAME,
                network_id: '',
                configs:
                  [
                    {
                      algorithm: 'roundrobin',
                      frontend_protocol: 'http',
                      backend_protocol: 'http',
                      connection_timeout: 60,
                      port: 65_500,
                      healthcheck:
                        {
                          check_interval: 60,
                          healthy_threshold: 10,
                          path: '/',
                          timeout: 60,
                          type: 'http',
                          unhealthy_threshold: 10
                        },
                      servers:
                        [
                          {
                            ipaddress: '0.4.1.2',
                            port: 80
                          }
                        ]
                    }
                  ]
              }
          )

          def test_create_loadbalancer(data)
            return output_skip_info('out limit') if limit?
            networks = do_command(:list_networks)
            lbs = do_command(:list_loadbalancers)
            data[:name] = make_unique_name(data[:name], lbs, 'name')
            data[:network_id] = networks.first['id']
            result = do_command(:create_loadbalancer, data)
            refute(result.empty?)
          end
        end
      end
    end
  end
end
