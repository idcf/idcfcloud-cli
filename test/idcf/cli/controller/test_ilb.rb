require 'test/unit'
require 'idcf/cli/controller/ilb'
require_relative './test_extend/output.rb'

module Idcf
  module Cli
    module Controller
      # test ilb
      class TestIlb < Test::Unit::TestCase
        include Idcf::Cli::Controller::TestExtend::Output

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
          init: {}
        )
        # not exists setting
        def test_init(data)
          assert_throw(:done) do
            target_class.init(data)
            throw(:done)
          end
        end

        data(
          success: {}
        )

        def test_make_client_success(data)
          client = @target.send(:make_client, data, target_class.get_region(data))
          refute(client.nil?)
        end

        data(
          no_region:     {
            region: 'a'
          },
          no_api_key:    {
            api_key: 'a'
          },
          no_secret_key: {
            secret_key: 'a'
          },
          no_key:        {
            api_key:    'a',
            secret_key: 'a'
          }
        )

        def test_option_error(data)
          assert_throw(:done) do
            begin
              @target.send(:do_command, :get_limit, [], data)
            rescue
              throw(:done)
            end
          end
        end
      end
    end
  end
end
