require 'test/unit'
require 'idcf/cli/conf/const'
require 'thor'
require 'idcf/cli/service/ilb/delete_server_for_protocol'
require 'idcf/cli/lib/test_util/include/api_create'
require 'idcf/cli/lib/test_util/ilb'

module Idcf
  module Cli
    module Service
      module Ilb
        # test base
        class TestDeleteServerForProtocol < Test::Unit::TestCase
          attr_reader :target, :lb

          include Idcf::Cli::Lib::TestUtil::Include::ApiCreate

          def setup
            @target = target_class.new
            @lb     = Idcf::Cli::Lib::TestUtil::Ilb.new
          end

          def cleanup
            @target = nil
          end

          def target_class
            Idcf::Cli::Service::Ilb::DeleteServerForProtocol
          end

          data(
            add: {
              protocol: 'http',
              port:     80,
              params:   {
                ipaddress: '0.0.0.2',
                port:      80
              }
            }
          )

          def test_do(data)
            lb_cls = @lb.target_class
            api    = make_api(lb_cls)
            o      = thor_options(lb_cls)
            lb     = @lb.find_test_lb
            return output_skip_info('not fround test lb') if lb.nil?
            befor = @target.last_command
            @target.__send__(:do, api, o, lb['id'], data[:protocol], data[:port], data[:params])
            after = @target.last_command
            assert_not_equal(befor, after)
          end
        end
      end
    end
  end
end
