require_relative '../test_ilb'

module Idcf
  module Cli
    module Controller
      module IlbCommand
        class TestLoadbalancer < Idcf::Cli::Controller::TestIlb
          self.test_order = :defined

          def setup
            @limit_param = 'loadbalancer_limit'
            @limit_action = 'list_loadbalancers'
            super
          end

          data(
            add:
              {
                name: 'test-cli-lb-',
                network_id: '',
                configs:
                  [
                    {
                      algorithm: 'roundrobin',
                      frontend_protocol: 'http',
                      backend_protocol: 'http',
                      connection_timeout: 60,
                      port: 80,
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

          data(
            update:
              {
                configs:
                  [
                    {
                      algorithm: 'roundrobin',
                      frontend_protocol: 'http',
                      backend_protocol: 'http',
                      port: 65_500,
                      connection_timeout: 30,
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
                          },
                          {
                            ipaddress: '0.4.1.3',
                            port: 80
                          }
                        ]
                    }
                  ]
              }
          )

          def test_update_loadbalancer(data)
            return output_skip_info('out limit') if limit?
            befor_lb = do_command(:list_loadbalancers).last
            lb_id = befor_lb['id']
            do_command(:update_loadbalancer, lb_id, data)
            after_lb = do_command(:get_loadbalancer, lb_id)
            befor_c = pickup_same_item(data, befor_lb)
            after_c = pickup_same_item(data, after_lb)
            assert_equal(befor_c, after_c)
          end

          data(
            list: {}
          )

          def test_list_loadbalancers(_data)
            result = do_command(:list_loadbalancers)
            refute(result.empty?)
          end

          data(
            get: {}
          )

          def test_get_loadbalancer(_data)
            lb = do_command(:list_loadbalancers).last
            result = do_command(:get_loadbalancer, lb['id'])
            check = pickup_same_item(lb, result)
            assert_equal(lb, check)
          end

          data(
            del: {}
          )

          def test_delete_loadbalancer(_data)
            return output_skip_info('out limit') if limit?
            befor_lbs = do_command(:list_loadbalancers)
            lb = befor_lbs.last
            do_command(:delete_loadbalancer, lb['id'])
            after_lbs = do_command(:list_loadbalancers)
            assert_equal(befor_lbs.size - 1, after_lbs.size)
          end
        end
      end
    end
  end
end
