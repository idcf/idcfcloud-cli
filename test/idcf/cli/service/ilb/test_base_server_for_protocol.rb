require 'test/unit'
require 'idcf/cli/conf/const'
require 'thor'
require 'idcf/cli/service/ilb/add_server_for_protocol'
require 'idcf/cli/lib/test_util/include/api_create'
require 'active_support'
require 'active_support/core_ext'

module Idcf
  module Cli
    module Service
      module Ilb
        # test base
        class TestBaseServerForProtocol < Test::Unit::TestCase
          include Idcf::Cli::Lib::TestUtil::Include::ApiCreate
          @target = nil

          def setup
            @target = target_class.new
          end

          def cleanup
            @target = nil
          end

          def target_class
            Idcf::Cli::Service::Ilb::BaseServerForProtocol
          end

          def lbs_sample
            [
              {
                'id'      =>
                  '98a8be20-43bc-4360-ac68-add8c08303e0',
                'configs' =>
                  [
                    {
                      'id'                => 'ec176633-6603-4fc5-a74f-ea83207c0000',
                      'port'              => 80,
                      'frontend_protocol' => 'http',
                      'backend_protocol'  => 'http',
                      'state'             => 'Running'
                    },
                    {
                      'id'                => 'ec176633-6603-4fc5-a74f-ea83207c0001',
                      'port'              => 8888,
                      'frontend_protocol' => 'http',
                      'backend_protocol'  => 'http',
                      'state'             => 'Running'
                    },
                    {
                      'id'                => 'ec176633-6603-4fc5-a74f-ea83207c0002',
                      'port'              => 443,
                      'frontend_protocol' => 'https',
                      'backend_protocol'  => 'http',
                      'state'             => 'Running'
                    }
                  ]
              },
              {
                'id'      =>
                  '98a8be20-43bc-4360-ac68-add8c08303e1',
                'configs' =>
                  [
                    {
                      'id'                => 'ec176633-6603-4fc5-a74f-ea83207c0010',
                      'port'              => 80,
                      'frontend_protocol' => 'http',
                      'backend_protocol'  => 'http',
                      'state'             => 'Create'
                    },
                    {
                      'id'                => 'ec176633-6603-4fc5-a74f-ea83207c0011',
                      'port'              => 8888,
                      'frontend_protocol' => 'http',
                      'backend_protocol'  => 'http',
                      'state'             => 'Updating'
                    },
                    {
                      'id'                => 'ec176633-6603-4fc5-a74f-ea83207c0012',
                      'port'              => 443,
                      'frontend_protocol' => 'https',
                      'backend_protocol'  => 'http',
                      'state'             => 'Expanding'
                    }
                  ]
              }
            ]
          end

          data(
            default: '<lb_id> <protocol> <protocol_port> <params>'
          )

          def test_make_param_s(data)
            assert_equal(target_class.__send__(:make_param_s), data)
          end

          data(
            default:
              [
                [:req, :lb_id],
                [:req, :protocol],
                [:req, :protocol_port],
                [:req, :params]
              ]
          )

          def test_valid_params(data)
            assert_equal(target_class.__send__(:valid_params), data)
          end

          data(
            default: 4
          )

          def test_between_param?(data)
            assert(@target.__send__(:between_param?, data))
          end

          data(
            lower: 3,
            over:  5
          )

          def test_refute_between_param?(data)
            assert_throw(:done) do
              begin
                @target.__send__(:between_param?, data)
              rescue
                throw(:done)
              end
            end
          end

          data(
            default: []
          )

          def test_do_command(data)
            assert_throw(:done) do
              begin
                @target.__send__(:do_command, *data)
              rescue
                throw(:done)
              end
            end
          end

          data(
            http:
              {
                target:   0,
                protocol: 'http',
                port:     80,
                result:   'ec176633-6603-4fc5-a74f-ea83207c0000'
              },
            http2:
              {
                target:   0,
                protocol: 'http',
                port:     8888,
                result:   'ec176633-6603-4fc5-a74f-ea83207c0001'
              },
            https:
              {
                target:   0,
                protocol: 'https',
                port:     443,
                result:   'ec176633-6603-4fc5-a74f-ea83207c0002'
              }
          )

          def test_search_config(data)
            config = @target.__send__(:search_config, lbs_sample[data[:target]], data[:protocol], data[:port])
            assert_equal(config['id'], data[:result])
          end

          data(
            http:
              {
                target:   1,
                protocol: 'http',
                port:     80,
                result:   'ec176633-6603-4fc5-a74f-ea83207c0010'
              },
            http2:
              {
                target:   1,
                protocol: 'http',
                port:     8888,
                result:   'ec176633-6603-4fc5-a74f-ea83207c0011'
              },
            https:
              {
                target:   1,
                protocol: 'https',
                port:     443,
                result:   'ec176633-6603-4fc5-a74f-ea83207c0012'
              }
          )

          def test_error_search_config(data)
            assert_throw(:done) do
              begin
                @target.__send__(:search_config, lbs_sample[data[:target]], data[:protocol], data[:port])
              rescue
                throw(:done)
              end
            end
          end

          data(
            assert:
              {
                protocol: 'http',
                port:     80,
                result:   true
              },
            refute:
              {
                protocol: 'https',
                port:     80,
                result:   false
              },
            refute2:
              {
                protocol: 'http',
                port:     8888,
                result:   false
              },
            refute3:
              {
                protocol: 'https',
                port:     8888,
                result:   false
              }
          )

          def test_target_config?(data)
            result = @target.__send__(:target_config?, lbs_sample[0]['configs'][0], data[:protocol], data[:port])
            assert_equal(result, data[:result])
          end
        end
      end
    end
  end
end
