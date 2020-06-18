require 'test/unit'
require 'idcf/cli/lib/api'
require 'idcf/cli/conf/const'
require 'idcf/json_hyper_schema'
require 'idcf/cli/conf/test_const'

module Idcf
  module Cli
    module Lib
      # test api
      class TestApi < Test::Unit::TestCase
        @target = nil

        def setup
          param   = { links: links }
          # MEMO:
          # The following warning appears in Ruby 2.7 series.
          #
          # Using the last argument as keyword parameters is deprecated; maybe ** should be added to the call
          #
          # If you want to support only Ruby 2.7 or higher, it is not necessary to distinguish between cases, but it is not so.
          @target = if RUBY_VERSION >= '2.7'
                      Idcf::Cli::Lib::Api.new(**param)
                    else
                      Idcf::Cli::Lib::Api.new(param)
                    end
        end

        def cleanup
          @target = nil
        end

        def links
          path = File.expand_path('api.json', Idcf::Cli::Conf::TestConst::DATA_DIR)
          Idcf::JsonHyperSchema::Analyst.new.load(path).links
        end

        data(
          no_param:
            {
              title:  'no_param',
              result: ''
            },
          uri_param:
            {
              title:  'uri_param',
              result: '<id>'
            },
          uri_param_two:
            {
              title:  'uri_param_two',
              result: '<id> <id2>'
            },
          get_param:
            {
              title:  'get_param',
              result: '[params]'
            },
          get_param_two:
            {
              title:  'get_param_two',
              result: '[params]'
            },
          get_param_required:
            {
              title:  'get_param_required',
              result: '<params>'
            },
          get_param_two_one_required:
            {
              title:  'get_param_two_one_required',
              result: '<params>'
            },
          get_param_two_all_required:
            {
              title:  'get_param_two_all_required',
              result: '<params>'
            },
          post_param:
            {
              title:  'post_param',
              result: '[params]'
            },
          post_param_required:
            {
              title:  'post_param_required',
              result: '<params>'
            },
          uri_get_param:
            {
              title:  'uri_get_param',
              result: '<id> [params]'
            },
          uri_get_param_required:
            {
              title:  'uri_get_param_required',
              result: '<id> <params>'
            },
          uri_post_param:
            {
              title:  'uri_post_param',
              result: '<id> [params]'
            },
          uri_post_param_required:
            {
              title:  'uri_post_param_required',
              result: '<id> <params>'
            },
          get_post_param:
            {
              title:  'get_post_param',
              result: '[params]'
            },
          get_post_param_get_required:
            {
              title:  'get_post_param_get_required',
              result: '<params>'
            },
          get_post_param_post_required:
            {
              title:  'get_post_param_post_required',
              result: '<params>'
            },
          get_post_param_required:
            {
              title:  'get_post_param_required',
              result: '<params>'
            },
          all_param:
            {
              title:  'all_param',
              result: '<id> [params]'
            },
          all_param_get_required:
            {
              title:  'all_param_get_required',
              result: '<id> <params>'
            },
          all_param_post_required:
            {
              title:  'all_param_post_required',
              result: '<id> <params>'
            },
          all_param_required:
            {
              title:  'all_param_required',
              result: '<id> <params>'
            }
        )

        def test_command_param_str(data)
          link   = @target.__send__(:find_link, data[:title])
          result = Idcf::Cli::Lib::Api.__send__(:command_param_str, link)
          assert_equal(result, data[:result])
        end

        data(
          not_found: {
            command: :not_found,
            list:    []
          }
        )

        def test_not_found_do(data)
          assert_throw(:done) do
            begin
              @target.__send_(:do, data[:command], *data[:list])
            rescue StandardError => _e
              throw(:done)
            end
          end
        end

        data(
          not_found: {
            command: :not_found,
            list:    []
          }
        )

        def test_not_found_result_api(data)
          assert_throw(:done) do
            begin
              @target.__send_(:do, data[:command], data[:list], {})
            rescue StandardError => _e
              throw(:done)
            end
          end
        end

        data(
          no_param:
            {
              title:  'no_param',
              params: %w[]
            },
          uri_param:
            {
              title:  'uri_param',
              params: %w[aaa]
            },
          uri_param_two:
            {
              title:  'uri_param_two',
              params: %w[aaa bbb]
            },
          get_param:
            {
              title:  'get_param',
              params: %w[]
            },
          get_param2:
            {
              title: 'get_param',
              params:
                     [
                       {
                         'hoge' => 'get_param'
                       }
                     ]
            },
          get_param_two:
            {
              title:  'get_param_two',
              params: %w[]
            },
          get_param_two2:
            {
              title: 'get_param_two',
              params:
                     [
                       {
                         'hoge' => 'get_hoge_param'
                       }
                     ]
            },
          get_param_two3:
            {
              title: 'get_param_two',
              params:
                     [
                       {
                         'hoge' => 'get_hoge_param',
                         'piyo' => 'get_piyo_param'
                       }
                     ]
            },
          get_param_required:
            {
              title: 'get_param_required',
              params:
                     [
                       {
                         'hoge' => 'get_hoge_param'
                       }
                     ]
            },
          get_param_two_one_required:
            {
              title: 'get_param_two_one_required',
              params:
                     [
                       {
                         'hoge' => 'get_hoge_param'
                       }
                     ]
            },
          get_param_two_all_required:
            {
              title: 'get_param_two_all_required',
              params:
                     [
                       {
                         'hoge' => 'get_hoge_param',
                         'piyo' => 'get_piyo_param'
                       }
                     ]
            },
          post_param:
            {
              title:  'post_param',
              params: %w[]
            },
          post_param_required:
            {
              title: 'post_param_required',
              params:
                     [
                       {
                         'post_id' => 'post_id_param'
                       }
                     ]
            },
          uri_get_param:
            {
              title: 'uri_get_param',
              params:
                     [
                       'aaa'
                     ]
            },
          uri_get_param2:
            {
              title: 'uri_get_param',
              params:
                     [
                       'aaa',
                       {
                         'hoge' => 'get_hoge_param'
                       }
                     ]
            },
          uri_get_param_required:
            {
              title: 'uri_get_param_required',
              params:
                     [
                       'aaa',
                       {
                         'hoge' => 'get_hoge_param'
                       }
                     ]
            },
          uri_post_param:
            {
              title: 'uri_post_param',
              params:
                     [
                       'aaa'
                     ]
            },
          uri_post_param2:
            {
              title: 'uri_post_param',
              params:
                     [
                       'aaa',
                       {
                         'post_id' => 'post_id_param'
                       }
                     ]
            },
          uri_post_param_required:
            {
              title: 'uri_post_param_required',
              params:
                     [
                       'aaa',
                       {
                         'post_id' => 'post_id_param'
                       }
                     ]
            },
          get_post_param:
            {
              title:  'get_post_param',
              params: %w[]
            },
          get_post_param2:
            {
              title: 'get_post_param',
              params:
                     [
                       {
                         'hoge' => 'get_hoge_param'
                       }
                     ]
            },
          get_post_param3:
            {
              title: 'get_post_param',
              params:
                     [
                       {
                         'post_id' => 'post_id_param'
                       }
                     ]
            },
          get_post_param4:
            {
              title: 'get_post_param',
              params:
                     [
                       {
                         'hoge'    => 'get_hoge_param',
                         'post_id' => 'post_id_param'
                       }
                     ]
            },
          get_post_param_get_required:
            {
              title: 'get_post_param_get_required',
              params:
                     [
                       {
                         'hoge' => 'get_hoge_param'
                       }
                     ]
            },
          get_post_param_post_required:
            {
              title: 'get_post_param_post_required',
              params:
                     [
                       {
                         'post_id' => 'post_id_param'
                       }
                     ]
            },
          get_post_param_required:
            {
              title: 'get_post_param_get_required',
              params:
                     [
                       {
                         'hoge'    => 'get_hoge_param',
                         'post_id' => 'post_id_param'
                       }
                     ]
            },
          all_param:
            {
              title: 'all_param',
              params:
                     [
                       'aaa'
                     ]
            },
          all_param2:
            {
              title: 'all_param',
              params:
                     [
                       'aaa',
                       {
                         'hoge' => 'get_hoge_param'
                       }
                     ]
            },
          all_param3:
            {
              title: 'all_param',
              params:
                     [
                       'aaa',
                       {
                         'post_id' => 'post_id_param'
                       }
                     ]
            },
          all_param4:
            {
              title: 'all_param',
              params:
                     [
                       'aaa',
                       {
                         'post_id' => 'post_id_param',
                         'hoge'    => 'get_hoge_param'
                       }
                     ]
            },
          all_param_get_required:
            {
              title: 'all_param_get_required',
              params:
                     [
                       'aaa',
                       {
                         'hoge' => 'get_hoge_param'
                       }
                     ]
            },
          all_param_post_required:
            {
              title: 'all_param_post_required',
              params:
                     [
                       'aaa',
                       {
                         'post_id' => 'post_id_param'
                       }
                     ]
            },
          all_param_required:
            {
              title: 'all_param_required',
              params:
                     [
                       'aaa',
                       {
                         'hoge'    => 'get_hoge_param',
                         'post_id' => 'post_id_param'
                       }
                     ]
            }
        )

        def test_between_param(data)
          link = @target.__send__(:find_link, data[:title])
          assert_throw(:done) do
            begin
              @target.__send__(:between_param, link, data[:params])
              throw(:done)
            rescue StandardError => _e
              throw(:error)
            end
          end
        end

        data(
          no_param:
            {
              title:  'no_param',
              params: %w[aaa]
            },
          uri_param:
            {
              title:  'uri_param',
              params: %w[]
            },
          uri_param2:
            {
              title:  'uri_param',
              params: %w[aaa bbb]
            },
          uri_param_two:
            {
              title:  'uri_param_two',
              params: %w[aaa]
            },
          uri_param_two2:
            {
              title:  'uri_param_two',
              params: %w[aaa bbb ccc]
            },
          get_param:
            {
              title:  'get_param',
              params: %w[aaa bbb]
            },
          get_param_two:
            {
              title:  'get_param_two',
              params: %w[aaa bbb]
            },
          get_param_required:
            {
              title:  'get_param_required',
              params: %w[]
            },
          get_param_required2:
            {
              title:  'get_param_required',
              params: %w[aaa bbb]
            },
          get_param_two_one_required:
            {
              title:  'get_param_two_one_required',
              params: %w[]
            },
          get_param_two_one_required2:
            {
              title:  'get_param_two_one_required',
              params: %w[aaa bbb]
            },
          get_param_two_all_required:
            {
              title:  'get_param_two_all_required',
              params: %w[]
            },
          get_param_two_all_required2:
            {
              title:  'get_param_two_all_required',
              params: %w[aaa bbb]
            },
          post_param_required:
            {
              title:  'post_param_required',
              params: %w[]
            },
          post_param_required2:
            {
              title:  'post_param_required',
              params: %w[aaa bbb ccc]
            },
          uri_get_param:
            {
              title:  'uri_get_param',
              params: %w[]
            },
          uri_get_param_required:
            {
              title:  'uri_get_param_required',
              params: %w[]
            },
          uri_get_param_required2:
            {
              title:  'uri_get_param_required',
              params: %w[aaa]
            },
          uri_get_param_required3:
            {
              title:  'uri_get_param_required',
              params: %w[aaa bbb ccc]
            },
          uri_post_param:
            {
              title:  'uri_post_param',
              params: %w[]
            },
          uri_post_param2:
            {
              title:  'uri_post_param',
              params: %w[aaa bbb ccc]
            },
          uri_post_param3:
            {
              title:  'uri_post_param',
              params: %w[aaa bbb ccc]
            },
          uri_post_param_required:
            {
              title:  'uri_post_param_required',
              params: %w[]
            },
          uri_post_param_required2:
            {
              title:  'uri_post_param_required',
              params: %w[aaa]
            },
          uri_post_param_required3:
            {
              title:  'uri_post_param_required',
              params: %w[aaa bbb ccc]
            },
          get_post_param_get_required:
            {
              title:  'get_post_param_get_required',
              params: %w[]
            },
          get_post_param_get_required2:
            {
              title:  'get_post_param_get_required',
              params: %w[aaa bbb]
            },
          get_post_param_post_required:
            {
              title:  'get_post_param_post_required',
              params: %w[]
            },
          get_post_param_post_required2:
            {
              title:  'get_post_param_post_required',
              params: %w[aaa bbb]
            },
          get_post_param_required:
            {
              title:  'get_post_param_required',
              params: %w[]
            },
          get_post_param_required2:
            {
              title:  'get_post_param_required',
              params: %w[aaa bbb]
            },
          all_param:
            {
              title:  'all_param',
              params: %w[]
            },
          all_param2:
            {
              title:  'all_param',
              params: %w[aaa bbb ccc]
            },
          all_param_get_required:
            {
              title:  'all_param_get_required',
              params: %w[]
            },
          all_param_get_required2:
            {
              title:  'all_param_get_required',
              params: %w[aaa]
            },
          all_param_post_required:
            {
              title:  'all_param_post_required',
              params: %w[]
            },
          all_param_post_required2:
            {
              title:  'all_param_post_required',
              params: %w[aaa]
            },
          all_param_required:
            {
              title:  'all_param_required',
              params: %w[]
            },
          all_param_required2:
            {
              title:  'all_param_required',
              params: %w[aaa]
            }
        )

        def test_error_between_param(data)
          link = @target.__send__(:find_link, data[:title])
          assert_throw(:done) do
            begin
              @target.__send__(:between_param, link, data[:params])
            rescue StandardError => _e
              throw(:done)
            end
          end
        end
      end
    end
  end
end
