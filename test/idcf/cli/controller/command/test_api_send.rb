require 'test/unit'
require 'idcf/cli/lib/test_util/ilb'

module Idcf
  module Cli
    module Controller
      module Command
        # test api send
        class TestApiSend < Test::Unit::TestCase
          self.test_order = :defined
          attr_reader :target

          def setup
            @target = Idcf::Cli::Lib::TestUtil::Ilb.new
          end

          def cleanup
            @target = nil
          end

          # skip info
          #
          # @param msg [String]
          def output_skip_info(msg)
            info = caller.first.split('/').pop(3).join('/')
            puts format("\nskip: %s \nmsg: %s", info, msg)
          end

          # pickup same item
          # Edit confirmation
          #
          # @param a [Mixed] Hash or Array
          # @param b [Mixed] Hash or Array
          # @return [Mixed] Hash or Array
          def pickup_same_item(a, b)
            result = nil
            if a.class == Hash
              result = {}
              a.each do |k, v|
                t_val = b[k]
                next if t_val.nil?
                result[k] = pickup_same_item_val(v, t_val)
              end
            elsif a.class == Array
              result = []
              a.each_index do |k|
                t_val = b[k]
                next if t_val.nil?
                result << pickup_same_item_val(a[k], t_val)
              end
            end

            result
          end

          def pickup_same_item_val(a, b)
            if b.class == Hash || b.class == Array
              pickup_same_item(a, b)
            else
              b
            end
          end

          data(
            get: nil
          )

          def test_get(_data)
            assert(@target.lb_list.class == Array)
          end

          data(
            post: nil
          )

          def test_post(_data)
            return output_skip_info('out limit') if @target.lb_limit?
            result = @target.create_lb
            refute(result.empty?)
          end

          data(
            update:
              {
                configs:
                  [
                    {
                      algorithm:          'roundrobin',
                      frontend_protocol:  'http',
                      backend_protocol:   'http',
                      port:               8_888,
                      connection_timeout: 30,
                      healthcheck:
                                          {
                                            check_interval:      60,
                                            healthy_threshold:   10,
                                            path:                '/',
                                            timeout:             60,
                                            type:                'http',
                                            unhealthy_threshold: 10
                                          },
                      servers:
                                          [
                                            {
                                              ipaddress: '0.4.1.2',
                                              port:      80
                                            },
                                            {
                                              ipaddress: '0.4.1.3',
                                              port:      80
                                            }
                                          ]
                    }
                  ]
              }
          )

          def test_put(data)
            befor_lb = @target.find_test_lb
            return output_skip_info('not init lb') if befor_lb.nil?
            lb_id = befor_lb['id']
            @target.do_command(:update_loadbalancer, [lb_id, data])
            after_lb = @target.do_command(:get_loadbalancer, [lb_id])
            befor_c  = pickup_same_item(data, befor_lb)
            after_c  = pickup_same_item(data, after_lb)
            assert_equal(befor_c, after_c)
          end

          data(
            connection_timeout:
              {
                connection_timeout: 40
              },
            port:
              {
                port: 8_000
              }
          )

          def test_patch_config_success(data)
            sleep 10
            lb = @target.find_test_lb
            return output_skip_info('not test lb') if lb.nil?
            config = lb['configs'].last
            assert_throw(:done) do
              @target.do_command(:patch_config, [lb['id'], config['id'], data])
              throw(:done)
            end
          end

          data(
            delete: nil
          )

          def test_delete(_data)
            lb = @target.find_test_lb
            return output_skip_info('not init lb') if lb.nil?
            befor_lbs = @target.lb_list
            @target.do_command(:delete_loadbalancer, lb['id'])
            after_lbs = @target.lb_list
            assert_equal(befor_lbs.size - 1, after_lbs.size)
          end
        end
      end
    end
  end
end
