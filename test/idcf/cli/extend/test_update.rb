require 'test/unit'
require 'idcf/cli/index'
require 'idcf/cli/conf/const'
require 'thor'

module Idcf
  module Cli
    module Extend
      # test update
      class TestUpdate < Test::Unit::TestCase
        @target = nil

        def setup
          Idcf::Cli::Index.init({})
          @target = Idcf::Cli::Index.new
        end

        def cleanup
          @target = nil
        end

        # data(
        #   your: {
        #     service: 'your',
        #     region:  'default'
        #   }
        # )
        #
        # def test_do_update(data)
        #   path  = @target.__send__:make_schema_file_path, data[:service], 'v1', data[:region])
        #   date1 = File.exist?(path) ? File.mtime(path).strftime('%Y%md%H%M%S') : nil
        #   sleep(1)
        #   @target.__send__(:do_update, {})
        #   date2 = File.mtime(path).strftime('%Y%md%H%M%S')
        #   assert_not_equal(date1, date2)
        # end

        data(
          one: {
            service: 'test',
            regions: {
              'v0': {
                '$version' => '0.0.0'
              }
            }
          },
          two: {
            service: 'test',
            regions: {
              'v0': {
                '$version' => '0.0.0'
              },
              'v1': {
                '$version' => '0.0.1'
              }
            }
          }
        )

        def test_output_default_schema(data)
          @target.__send__(:output_default_schema, data[:service], 'v1', data[:regions])
          path   = @target.__send__(:make_schema_file_path, data[:service], 'v1', 'default')
          result = File.exist?(path)
          File.unlink(path) if result
          assert(result)
        end

        data(
          default: {
            service: 'test',
            regions: {
              'default' => {}
            }
          },
          one:     {
            service: 'test',
            regions: {
              'default' => {},
              'v0'      => {
                '$version' => '0.0.0'
              }
            }
          }
        )

        def test_no_create_output_default_schema(data)
          @target.__send__(:output_default_schema, data[:service], 'v1', data[:regions])
          path   = @target.__send__(:make_schema_file_path, data[:service], 'v1', 'default')
          result = File.exist?(path)
          File.unlink(path) if result
          refute(result)
        end

        data(
          one: {
            schemas:
              [
                {
                  '$version' => '0.1.0'
                }
              ]
          },
          two: {
            schemas:
              [
                {
                  '$version' => '0.0.0'
                },
                {
                  '$version' => '0.1.0'
                }
              ]
          }
        )

        def test_latest_schema(data)
          schema = @target.__send__(:latest_schema, data[:schemas])
          assert_equal(schema['$version'], '0.1.0')
        end

        data(
          top:
            {
              service: 'top',
              command: 'init'
            },
          ilb_schema_exist:
            {
              service: 'ilb',
              command: 'add_server'
            },
          ilb_add_command:
            {
              service: 'ilb',
              command: 'add_server_for_protocol'
            }
        )

        def test_make_script_variables(data)
          result = @target.__send__(:make_script_variables)
          assert(result[data[:service]].include?(data[:command]))
        end

        data(
          flat: {
            befor: {
              'test' => nil,
              'aa'   => nil,
              'hoge' => {
                'test2' => nil,
                'bb'    => nil,
                'piyo'  => {
                  'test3' => nil,
                  'cc'    => nil
                },
                'fuga'    => {
                  'test3' => nil,
                  'dd'    => nil
                }
              },
              'piyo' => {}
            },
            after: {
              'top'       => %w(test aa hoge piyo),
              'hoge'      => %w(test2 bb piyo fuga),
              'hoge_piyo' => %w(test3 cc),
              'hoge_fuga' => %w(test3 dd),
              'piyo'      => %w()
            }
          }
        )

        def test_make_flat_variables(data)
          result = @target.__send__(:make_flat_variables, data[:befor])
          assert_equal(result, data[:after])
        end
      end
    end
  end
end
