require 'test/unit'
require 'idcf/cli/controller/base'

module Idcf
  module Cli
    module Controller
      class TestBase < Test::Unit::TestCase
        @target = nil

        def setup
          @target = target_class_name.new
        end

        def cleanup
          @target = nil
        end

        def target_class_name
          Idcf::Cli::Controller::Base
        end

        data(init: '')
        # not exists setting
        def test_init(_data)
          assert_throw(:done) do
            begin
              Idcf::Cli::Controller::Base.init
              throw(:error)
            rescue
              throw(:done)
            end
          end
        end

        data(
          api_key: 'api_key'
        )

        def test_get_user_conf_success(data)
          assert_equal(!@target.send(:get_user_conf, data).nil?, true)
        end

        data(
          api_key: :api_key,
          error: 'hoge'
        )

        def test_get_user_conf_error(data)
          assert_throw(:done) do
            begin
              @target.send(:get_user_conf, data)
            rescue
              throw(:done)
            end
          end
        end

        data(
          output:
            [
              'output',
              {}
            ],
          host:
            [
              'ilb.v1.host.jp-east',
              {}
            ],
          section:
            [
              'output',
              {
                section: 'default'
              }
            ],
          no_section:
            [
              'output',
              {
                section: 'hogepiyo'
              }
            ]
        )

        def test_get_code_conf_success(data)
          assert_equal(!@target.send(:get_code_conf, *data).nil?, true)
        end

        data(
          not_path:
            [
              'hoge',
              {}
            ]
        )

        def test_get_code_conf_error(data)
          assert_throw(:done) do
            begin
              @target.send(:get_code_conf, *data)
            rescue
              throw(:done)
            end
          end
        end

        data(empty: '')

        def test_make_module_classes_empty(_data)
          result = target_class_name.make_module_classes
          assert_equal(result.empty?, true)
        end

        data(
          empty1: nil,
          empty2: []
        )

        def test_make_param_s_empty(data)
          result = target_class_name.make_param_s(data)
          assert_equal(result.empty?, true)
        end

        data(
          one:
            [
              {
                name: 'name1',
                arg_type: ''
              }
            ]
        )

        def test_make_param_s_one(data)
          result = target_class_name.make_param_s(data)
          assert_equal(result, '<name1>')
        end

        data(
          two:
            [
              {
                name: 'name1',
                arg_type: ''
              }, {
                name: 'name2',
                arg_type: ''
              }
            ]
        )

        def test_make_param_s_two(data)
          result = target_class_name.make_param_s(data)
          assert_equal(result, '<name1> <name2>')
        end

        data(
          error_msg: 'status code: 500,test error'
        )

        def test_make_error_status_code(data)
          raise data
        rescue => e
          check_data = {
            status: 500,
            message: data,
            data: []
          }
          assert_equal(@target.send(:make_error, e), check_data)
        end

        data(
          error_msg: 'test error'
        )

        def test_make_error_no_status_code(data)
          raise data
        rescue => e
          check_data = {
            status: 400,
            message: data,
            data: []
          }
          assert_equal(@target.send(:make_error, e), check_data)
        end

        data(
          valid_e1: {
            test: 'aaa'
          },
          valid_e2: {
            test: 'aaa',
            test2: 'bbb'
          },
          valid_arr_e1: %w(aaa),
          valid_arr_e2: %w(aaa bbb)
        )

        def test_make_validation_error(data)
          check_data = {
            status: 400,
            message: data,
            data: []
          }
          assert_equal(@target.send(:make_validation_error, data), check_data)
        end

        data(
          csv_a:
            [
              [],
              {
                output: 'csv'
              }
            ],
          csv_h:
            [
              {},
              {
                output: 'csv'
              }
            ],
          csv_s:
            [
              'str',
              {
                output: 'csv'
              }
            ],
          table_a:
            [
              [],
              {
                output: 'table'
              }
            ],
          table_h:
            [
              {},
              {
                output: 'table'
              }
            ],
          table_s:
            [
              'str',
              {
                output: 'table'
              }
            ]
        )

        def test_make_result_data_dimension(data)
          assert_equal(@target.send(:make_result_data, *data), data[0])
        end

        data(
          xml_a:
            [
              [],
              {
                output: 'xml'
              }
            ],
          xml_h:
            [
              {},
              {
                output: 'xml'
              }
            ],
          xml_s:
            [
              'str',
              {
                output: 'xml'
              }
            ],
          json_s:
            [
              [],
              {
                output: 'json'
              }
            ],
          json_a:
            [
              [],
              {
                output: 'json'
              }
            ],
          json_h:
            [
              {},
              {
                output: 'json'
              }
            ],
          default:
            [
              [],
              {}
            ]
        )

        def test_make_result_data_normal(data)
          check_data = {
            status: 200,
            message: '',
            data: data[0]
          }
          assert_equal(@target.send(:make_result_data, *data), check_data)
        end

        data(
          exist:
            {
              in: 'default',
              out: 'default'
            },
          not_found:
            {
              in: 'found',
              out: 'default'
            }
        )

        def test_get_section(data)
          assert_equal(@target.send(:get_profile, section: data[:in]), data[:out])
        end
      end
    end
  end
end
