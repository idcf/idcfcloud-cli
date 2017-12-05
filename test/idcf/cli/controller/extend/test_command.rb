require 'test/unit'
require 'idcf/cli/controller/ilb'
require 'idcf/cli/conf/test_const'
require 'idcf/cli/service/base'

module Idcf
  module Cli
    module Controller
      module Extend
        # test command
        class TestCommand < Test::Unit::TestCase
          @target = nil
          @api    = nil

          def setup
            @target = target_class.new
            path    = File.expand_path('command.json', Idcf::Cli::Conf::TestConst::DATA_DIR)
            param   = { links: Idcf::JsonHyperSchema::Analyst.new.load(path).links }
            @api    = Idcf::Cli::Lib::Api.new(param)
          end

          def cleanup
            @target = nil
          end

          def target_class
            Idcf::Cli::Controller::Ilb
          end

          data(
            regist_check: 'regist_check'
          )

          def test_register_schema_method_by_link!(data)
            link = @api.__send__(:find_link, data)
            target_class.__send__(:register_schema_method_by_link!, link)
            assert(target_class.new.methods.include?(data.to_sym))
          end

          data(
            service_base:
              {
                name: 'base',
                cls:  Idcf::Cli::Service::Base
              }
          )

          def test_register_module_method!(data)
            target_class.__send__(:register_module_method!, data[:name], data[:cls])
            assert(target_class.new.methods.include?(data[:name].to_sym))
          end
        end
      end
    end
  end
end
