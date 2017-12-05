require 'test/unit'
require 'idcf/cli/controller/base'

module Idcf
  module Cli
    module Controller
      # test base
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
      end
    end
  end
end
