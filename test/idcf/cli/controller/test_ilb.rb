require 'test/unit'
require 'idcf/cli/controller/ilb'
require_relative './test_extend/util.rb'
require_relative './test_extend/output.rb'

module Idcf
  module Cli
    module Controller
      class TestIlb < Test::Unit::TestCase
        include Idcf::Cli::Controller::TestExtend::Util
        include Idcf::Cli::Controller::TestExtend::Output

        CLIENT_OPTIONS = {
          region: 'jp-west'
        }.freeze
        TEST_NAME = 'test-cli-lb-'.freeze
        @target = nil
        @limit_param = ''
        @limit_action = ''
        @client = nil
        @option = {}

        class << self
          attr_reader :limits

          def startup
            target = Idcf::Cli::Controller::Ilb.new
            option = {
              region: 'jp-west'
            }
            args = []
            @limits = target.send(:do_command, :get_limit, *args, option)
            raise 'not get limit infos' if @limits.nil? || @limits.empty?
          end
        end

        def setup
          @target = target_class.new
          @option = {}
        end

        def cleanup
          @target = nil
        end

        def target_class
          Idcf::Cli::Controller::Ilb
        end

        def make_client
          return @client unless @client.nil?
          @client = @target.send(:make_client, CLIENT_OPTIONS)
        end

        def add_option(value)
          @option = value
        end

        def do_command(command, *args)
          op = CLIENT_OPTIONS.merge(@option)
          @target.send(:do_command, command, *args, op)
        end

        def limit?
          limit = self.class.limits[@limit_param]
          cnt = do_command(@limit_action.to_sym, {}).size
          cnt >= limit
        end

        def find_test_lb
          client = make_client
          client.get('loadbalancers').body.each do |v|
            return v if v['name'] =~ /#{TEST_NAME}\d+/ && v['state'] == 'Running'
          end
        end

        data(init: '')
        # not exists setting
        def test_init(_data)
          assert_throw(:done) do
            target_class.init
            throw(:done)
          end
        end

        data(empty: '')

        def test_make_module_classes_not_empty(_data)
          list = target_class.make_module_classes
          refute(list.empty?)
        end

        data(
          blank_client: {}
        )

        def test_make_blank_client_success(_data)
          client = target_class.make_blank_client
          refute(client.nil?)
        end

        data(
          client: {
            region: 'jp-west'
          }
        )

        def test_make_client_success(data)
          client = @target.send(:make_client, data)
          refute(client.nil?)
        end

        data(
          no_region: {
            region: 'a'
          },
          no_api_key: {
            api_key: 'a'
          },
          no_secret_key: {
            secret_key: 'a'
          },
          no_key: {
            api_key: 'a',
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
