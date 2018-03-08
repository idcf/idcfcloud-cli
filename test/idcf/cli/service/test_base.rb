require 'test/unit'
require 'idcf/cli/conf/const'
require 'thor'
require 'idcf/cli/service/base'

module Idcf
  module Cli
    module Service
      # test base
      class TestBase < Test::Unit::TestCase
        @target = nil

        def setup
          @target = target_class.new
        end

        def cleanup
          @target = nil
        end

        def target_class
          Idcf::Cli::Service::Base
        end

        data(
          type:
            {
              name: 'type',
              opt:
                    {
                      type: 'string'
                    }
            },
          required:
            {
              name: 'type',
              opt:
                    {
                      requred: true
                    }
            },
          desc:
            {
              name: 'type',
              opt:
                    {
                      desc: 'test_description'
                    }
            },
          mix:
            {
              name: 'type',
              opt:
                    {
                      type: 'string',
                      desc: 'description'
                    }
            }
        )

        def test_option(data)
          target_class.__send__(:option, data[:name], data[:opt])
          assert_equal(target_class.options[data[:name]], data[:opt])
        end

        data(
          reset: nil
        )

        def test_reset(_data)
          before = target_class.options.size
          target_class.__send__(:reset)
          after = target_class.options.size
          refute_equal(before, after)
        end

        data(
          none: nil
        )

        def test_make_param_s(_data)
          assert(target_class.__send__(:make_param_s).empty?)
        end

        data(
          none: nil
        )

        def test_valid_params(_data)
          assert(target_class.__send__(:valid_params).empty?)
        end

        data(
          val: 'value'
        )

        def test_target_params(data)
          assert(target_class.__send__(:target_param?, data))
        end

        data(
          api:                'api',
          o:                  'o',
          under_score:        '_',
          under_score_string: '_a'
        )

        def test_refute_target_params(data)
          refute(target_class.__send__(:target_param?, data))
        end

        data(
          none: 0
        )

        def test_between_param?(data)
          assert(@target.__send__(:between_param?, data))
        end

        data(
          over: 1
        )

        def test_refute_between_param?(data)
          assert_throw(:done) do
            begin
              @target.__send__(:between_param?, data)
            rescue StandardError => _e
              throw(:done)
            end
          end
        end

        data(
          rest:
            [
              [:rest, :hoge]
            ],
          rest2:
            [
              [:rest, :hoge],
              [:rest, :piyo]
            ],
          mix:
            [
              [:rest, :hoge],
              [:req, :piyo]
            ]
        )

        def test_method_rest?(data)
          assert(@target.__send__(:method_rest?, data))
        end

        data(
          none: nil,
          req:
                [
                  [:req, :hoge]
                ],
          opt:
                [
                  [:opt, :hoge]
                ],
          mix:
                [
                  [:req, :hoge],
                  [:opt, :piyo]
                ]
        )

        def test_refute_method_rest?(data)
          refute(@target.__send__(:method_rest?, data))
        end

        data(
          none:
            {
              data:   [],
              result: 0
            },
          req:
            {
              data:
                      [
                        [:req, :hoge]
                      ],
              result: 0
            },
          rest:
            {
              data:
                      [
                        [:rest, :hoge]
                      ],
              result: 0
            },
          opt:
            {
              data:
                      [
                        [:opt, :hoge]
                      ],
              result: 1
            },
          opt2:
            {
              data:
                      [
                        [:opt, :hoge],
                        [:opt, :piyo]
                      ],
              result: 2
            },
          mix:
            {
              data:
                      [
                        [:req, :hoge],
                        [:opt, :piyo]
                      ],
              result: 1
            }
        )

        def test_method_option_cnt(data)
          assert_equal(@target.__send__(:method_option_cnt, data[:data]), data[:result])
        end
      end
    end
  end
end
