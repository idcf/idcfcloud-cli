require 'idcf/cli/conf/test_const'
require 'idcf/cli/lib/api'
require 'idcf/cli/lib/test_util/include/api_create'
require 'idcf/cli/controller/ilb'

module Idcf
  module Cli
    module Lib
      module TestUtil
        class Ilb
          attr_reader :controller
          LB_DATA = {
            name:
              Idcf::Cli::Conf::TestConst::TEST_NAME,
            network_id:
              '',
            configs:
              [
                {
                  algorithm:          'roundrobin',
                  frontend_protocol:  'http',
                  backend_protocol:   'http',
                  connection_timeout: 60,
                  port:               80,
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
                                          ipaddress: '0.0.0.0',
                                          port:      80
                                        }
                                      ]
                }
              ]
          }.freeze

          include Idcf::Cli::Lib::TestUtil::Include::ApiCreate

          def initialize
            cls = target_class
            cls.init(Idcf::Cli::Conf::TestConst::OPTION_STR_LIST)
            @controller = cls.new
          end

          def target_class
            Idcf::Cli::Controller::Ilb
          end

          # unique name
          #
          # @param base_name [String]
          # @param hashes [Array]
          # @return [String]
          def make_unique_name(base_name, hashes)
            result = base_name
            loop do
              name = "#{result}#{rand(0..1000)}"
              flg  = false
              if hashes.class == Array
                hashes.each do |v|
                  flg = true if v['name'] == name
                end
              end

              unless flg
                result = name
                break
              end
            end
            result
          end

          def do_command(command, data = [])
            @controller.__send__(:run, command, data, thor_options(target_class))
          end

          def lb_list
            do_command(:list_loadbalancers)[:data]
          end

          def lb_limit?
            lb    = lb_list
            limit = do_command(:get_limit)[:data]
            lb.size >= limit['loadbalancer_limit']
          end

          def find_test_lb
            lb_list.each do |v|
              test_name = Idcf::Cli::Conf::TestConst::TEST_NAME
              return v if v['name'] =~ /#{test_name}\d+/ && v['state'] == 'Running'
            end
            nil
          end

          def create_lb
            data              = LB_DATA.dup
            networks          = do_command(:list_networks)
            lbs               = lb_list
            data[:name]       = make_unique_name(data[:name], lbs)
            data[:network_id] = networks[:data].first['id']
            do_command(:create_loadbalancer, [data])
          end
        end
      end
    end
  end
end
