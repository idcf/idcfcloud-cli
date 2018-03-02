require 'test/unit'
require 'idcf/cli/lib/test_util/ilb'
require 'idcf/cli/lib/test_util/include/api_create'

module Idcf
  module Cli
    module Service
      module Ilb
        # test data create
        class TestZ < Test::Unit::TestCase
          self.test_order = :defined
          attr_reader :target
          include Idcf::Cli::Lib::TestUtil::Include::ApiCreate

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
            info = caller(1..1).first.split('/').pop(3).join('/')
            puts format("\nskip: %<info>s \nmsg: %<msg>s", info: info, msg: msg)
          end

          data(
            delete: nil
          )

          def test_delete(_data)
            lb = @target.find_test_lb
            return output_skip_info('not found test lb') if lb.nil?
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
