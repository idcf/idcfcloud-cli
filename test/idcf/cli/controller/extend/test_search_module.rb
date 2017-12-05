require 'test/unit'
require 'idcf/cli/controller/ilb'
require 'idcf/cli/conf/test_const'

module Idcf
  module Cli
    module Extend
      module Controller
        # test serch module
        class TestSearchModule < Test::Unit::TestCase
          @target = nil

          def setup
            @target = target_class.new
          end

          def cleanup
            @target = nil
          end

          def target_class
            Idcf::Cli::Controller::Ilb
          end

          data(
            base:
              {
                cls:    Idcf::Cli::Controller::Base,
                result: true
              },
            exist:
              {
                cls:    Idcf::Cli::Controller::Ilb,
                result: false
              }
          )

          def test_make_service_paths(data)
            data[:cls].make_service_paths
            list = data[:cls].__send__(:make_service_paths)
            assert(list.empty? == data[:result])
          end

          data(
            base:
              {
                cls:    Idcf::Cli::Controller::Base,
                result: true
              },
            exist:
              {
                cls:    Idcf::Cli::Controller::Ilb,
                result: false
              }
          )

          def test_not_base_make_service_paths(data)
            data[:cls].make_service_paths
            list   = data[:cls].__send__(:make_service_paths)
            result = list.select do |k, _v|
              !k.index('base_').nil?
            end
            assert(result.empty?)
          end
        end
      end
    end
  end
end
