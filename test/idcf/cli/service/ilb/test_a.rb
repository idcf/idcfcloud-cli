require 'test/unit'
require 'idcf/cli/lib/test_util/ilb'
require 'idcf/cli/lib/test_util/include/api_create'

module Idcf
  module Cli
    module Service
      module Ilb
        # test data create
        class TestA < Test::Unit::TestCase
          self.test_order = :defined
          attr_reader :target
          include Idcf::Cli::Lib::TestUtil::Include::ApiCreate

          def setup
            @target = Idcf::Cli::Lib::TestUtil::Ilb.new
          end

          def cleanup
            @target = nil
          end

          data(
            post: nil
          )

          def test_post(_data)
            return output_skip_info('out limit') if @target.lb_limit?
            result = @target.create_lb
            refute(result.empty?)
          end
        end
      end
    end
  end
end
