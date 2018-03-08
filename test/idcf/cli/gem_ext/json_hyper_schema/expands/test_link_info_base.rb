require 'test/unit'
require 'idcf/cli/conf/const'
require 'idcf/json_hyper_schema'
require 'idcf/json_hyper_schema/expands/link_info_base'
require 'idcf/cli/conf/test_const'
require 'idcf/cli/gem_ext/idcf/json_hyper_schema/expands/link_info_base_extension'

module Idcf
  module Cli
    module GemExt
      module JsonHyperSchema
        module Expands
          # test link info base
          class TestLinkInfoBase < Test::Unit::TestCase
            @target = nil

            def setup
              path    = File.expand_path('link_ext.json', Idcf::Cli::Conf::TestConst::DATA_DIR)
              analyst = Idcf::JsonHyperSchema::Analyst.new
              @links  = analyst.load(path).links
            end

            def cleanup
              @target = nil
            end

            def find_link(title)
              @links.each do |link|
                return link if link.title == title
              end
              nil
            end

            data(
              async:
                {
                  title:  'async',
                  result: true
                },
              no_async:
                {
                  title:  'no_async',
                  result: false
                },
              no_async2:
                {
                  title:  'no_async2',
                  result: false
                }
            )

            def test_async?(data)
              link = find_link(data[:title])
              assert_equal(link.async?, data[:result])
            end

            data(
              no_result_api:
                {
                  title:  'no_result_api',
                  result: ''
                },
              result_api:
                {
                  title:  'result_api',
                  result: 'hoge'
                }
            )

            def test_result_api_title(data)
              link = find_link(data[:title])
              assert_equal(link.result_api_title, data[:result])
            end

            data(
              undefined_result_api:
                {
                  title:  'undefined_result_api',
                  result: []
                },
              result_api_no_param:
                {
                  title:  'result_api_no_param',
                  result: []
                },
              result_api_no_param2:
                {
                  title:  'result_api_no_param2',
                  result: []
                },
              result_api_1_str_params:
                {
                  title:  'result_api_1_str_params',
                  result: %w[aaa]
                },
              result_api_2_str_params:
                {
                  title:  'result_api_2_str_params',
                  result: %w[aaa bbb]
                },
              result_api_numeric_params:
                {
                  title:  'result_api_numeric_params',
                  result: [1]
                },
              result_api_str_and_numeric_params:
                {
                  title: 'result_api_str_and_numeric_params',
                  result:
                         [
                           'aaa',
                           1
                         ]
                },
              result_api_array_params:
                {
                  title: 'result_api_array_params',
                  result:
                         [
                           [
                             'aaa',
                             1
                           ]
                         ]
                },
              result_api_nest_array_params:
                {
                  title: 'result_api_nest_array_params',
                  result:
                         [
                           [
                             [
                               'aaa',
                               1
                             ]
                           ]
                         ]
                },
              result_api_empty_hash_params:
                {
                  title: 'result_api_empty_hash_params',
                  result:
                         [
                           {}
                         ]
                },
              result_api_hash_params:
                {
                  title: 'result_api_hash_params',
                  result:
                         [
                           {
                             'aaa' => 'bbb'
                           }
                         ]
                },
              result_api_hash_nest_array_params:
                {
                  title: 'result_api_hash_nest_array_params',
                  result:
                         [
                           {
                             'aaa' => %w[bbb ccc]
                           }
                         ]
                },
              result_api_nest_hash_params:
                {
                  title: 'result_api_nest_hash_params',
                  result:
                         [
                           {
                             'aaa' => {
                               'bbb' => 'ccc'
                             }
                           }
                         ]
                },
              result_api_input_param:
                {
                  title:  'result_api_input_param',
                  args:   %w[input_value1],
                  result: %w[input_value1]
                },
              result_api_result_param:
                {
                  title:  'result_api_result_param',
                  args:   %w[input_value1],
                  result: %w[configure_0]
                },
              result_api_result_param2:
                {
                  title:  'result_api_result_param2',
                  args:   %w[input_value1],
                  result: %w[configure_1_name]
                },
              result_api_not_async_resource_id_param:
                {
                  title: 'result_api_not_async_resource_id_param',
                  args:  %w[input_value1],
                  result:
                         [nil]
                },
              result_api_async_resource_id_param:
                {
                  title:  'result_api_async_resource_id_param',
                  args:   %w[input_value1],
                  result: %w[resource_001]
                },
              result_api_input_and_result_param:
                {
                  title:  'result_api_input_and_result_param',
                  args:   %w[input_value1],
                  result: %w[input_value1 configure_0]
                },
              result_api_all_param:
                {
                  title:  'result_api_all_param',
                  args:   %w[input_value1],
                  result: %w[input_value1 configure_0 resource_001]
                },
              result_api_hash_param:
                {
                  title: 'result_api_hash_param',
                  args:  %w[input_value1 input_value2],
                  result:
                         [
                           'input_value1',
                           {
                             'input' => 'input_value2',
                             'param' => {
                               'conf0_id'   => 'configure_0',
                               'conf1_name' => 'configure_1_name'
                             }
                           }
                         ]
                }
            )

            def test_result_api_params(data)
              link        = find_link(data[:title])
              args        = data[:args] || []
              api_result  = {
                'configures' => [
                  {
                    'id'   => 'configure_0',
                    'name' => 'configure_0_name'
                  },
                  {
                    'id'   => 'configure_1',
                    'name' => 'configure_1_name'
                  }
                ]
              }
              resource_id = link.async? ? 'resource_001' : nil
              assert_equal(link.result_api_params(args, api_result, resource_id), data[:result])
            end

            data(
              result_api_not_found_input_param:  'result_api_not_found_input_param',
              result_api_not_found_result_param: 'result_api_not_found_result_param'
            )

            def test_error_result_api_params(data)
              link = find_link(data)
              assert_throw(:done) do
                begin
                  link.result_api_params([], {}, nil)
                rescue StandardError => _e
                  throw(:done)
                end
              end
            end
          end
        end
      end
    end
  end
end
