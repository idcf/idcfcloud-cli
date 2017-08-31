require 'test/unit'
require 'idcf/cli/controller/your'
require 'date'

module Idcf
  module Cli
    module Controller
      class TestYour < Test::Unit::TestCase
        @target = nil

        def setup
          @target = target_class.new
        end

        def cleanup
          @target = nil
        end

        def target_class
          Idcf::Cli::Controller::Your
        end

        data(init: '')
        # not exists setting
        def test_init(_data)
          assert_throw(:done) do
            target_class.init
            throw(:done)
          end
        end

        data(
          blank_client: {}
        )

        def test_make_blank_client(_data)
          client = target_class.make_blank_client
          refute(client.nil?)
        end

        data(
          success: {}
        )

        def test_make_client_success(data)
          client = @target.send(:make_client, data)
          refute(client.nil?)
        end

        data(
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
              @target.send(:do_command, :history, [], data)
            rescue
              throw(:done)
            end
          end
        end
      end
    end
  end
end
