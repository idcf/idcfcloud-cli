require 'test/unit'
require 'idcf/cli/controller/your'
require 'date'
require 'idcf/cli/conf/test_const'

module Idcf
  module Cli
    module Controller
      # test your
      class TestYour < Test::Unit::TestCase
        @target = nil

        def setup
          cls = target_class
          target_class.init(Idcf::Cli::Conf::TestConst::OPTION_STR_LIST)
          @target = cls.new
        end

        def cleanup
          @target = nil
        end

        def target_class
          Idcf::Cli::Controller::Your
        end

        data(init: {})
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
            rescue StandardError => _e
              throw(:done)
            end
          end
        end
      end
    end
  end
end
