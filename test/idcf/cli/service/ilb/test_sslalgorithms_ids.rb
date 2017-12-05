require 'test/unit'
require 'idcf/cli/service/ilb/sslalgorithms_ids'
require 'idcf/cli/controller/ilb'
require 'idcf/cli/lib/test_util/ilb'
require 'idcf/cli/lib/test_util/include/api_create'

module Idcf
  module Cli
    module Service
      module Ilb
        # test check job
        class TestSslalgorithmsIds < Test::Unit::TestCase
          attr_reader :target, :lb

          include Idcf::Cli::Lib::TestUtil::Include::ApiCreate

          def setup
            @target = Idcf::Cli::Service::Ilb::SslalgorithmsIds.new
            @lb     = Idcf::Cli::Lib::TestUtil::Ilb.new
          end

          def cleanup
            @target = nil
          end

          def ilb_class
            Idcf::Cli::Controller::Ilb
          end

          data(
            ids: nil
          )

          def test_do(_data)
            api = make_api(ilb_class)
            o   = thor_options(ilb_class)
            refute(@target.__send__(:do, api, o).empty?)
          end
        end
      end
    end
  end
end
