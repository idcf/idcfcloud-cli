require 'test/unit'
require 'idcf/cli/index'
require 'idcf/cli/conf/const'
require 'thor'

module Idcf
  module Cli
    module Extend
      class TestIndex < Test::Unit::TestCase
        @target = nil

        def setup
          Idcf::Cli::Index.init
          @target = Idcf::Cli::Index.new
        end

        def cleanup
          @target = nil
        end

        data(client: {})

        def test_make_client(_data)
          result = @target.send(:make_clients)
          refute(result.empty?)
        end

        data(
          service:     ['billing'],
          not_service: ['hoge']
        )

        def test_setting_file_writable(data)
          result = @target.send(:writable_setting_file, data)
          assert(result)
        end

        data(client: {})

        def test_make_module_info(_data)
          clients = @target.send(:make_clients)
          result  = @target.send(:make_module_info, clients.first[1])
          refute(result.empty?)
        end

        data(
          array: [],
          hash:  {},
          str:   'a',
          nil:   nil
        )

        def test_make_module_info_outside(data)
          result = @target.send(:make_module_info, data)
          assert(result.empty?)
        end

        data(
          exists_a:
            [
              [],
              :size
            ],
          exists_nil:
            [
              nil,
              :nil?
            ]
        )

        def test_make_method_info(data)
          result = @target.send(:make_method_info, *data)
          refute(result.empty?)
        end

        data(
          not_exists:
            [
              [],
              :hogehoge
            ]
        )

        def test_make_method_info_outside(data)
          assert_throw(:done) do
            begin
              @target.send(:make_method_info, *data)
            rescue
              throw(:done)
            end
          end
        end

        data(
          command_str: Thor
        )
        def test_command_string(data)
          result = @target.send(:extract_commands, data, [])
          refute(result.empty?)
        end
      end
    end
  end
end
