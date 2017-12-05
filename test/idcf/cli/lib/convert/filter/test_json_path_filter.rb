require 'test/unit'
require 'idcf/cli/lib/convert/filter/json_path_filter'

module Idcf
  module Cli
    module Lib
      module Convert
        module Filter
          # test json path filter
          class TestJsonPathFilter < Test::Unit::TestCase
            @target = nil

            def setup
              @target = JsonPathFilter.new
            end

            def cleanup
              @target = nil
            end

            data(
              none:   {
                data:      nil,
                condition: '',
                result:    nil
              },
              str:    {
                data:      'data_str',
                condition: '',
                result:    'data_str'
              },
              number: {
                data:      12_345,
                condition: '',
                result:    12_345
              },
              true:   {
                data:      true,
                condition: '',
                result:    true
              },
              false:
                      {
                        data:      false,
                        condition: '',
                        result:    false
                      },
              empty_array:
                      {
                        data:      [],
                        condition: '',
                        result:    [[]]
                      },
              empty_hash:
                      {
                        data:      {},
                        condition: '',
                        result:    [{}]
                      },
              select_data:
                      {
                        data:
                                   [
                                     {
                                       id:   'id_1',
                                       name: 'name_1'
                                     },
                                     {
                                       id:   'id_2',
                                       name: 'name_2'
                                     }
                                   ],
                        condition: '$.[1]',
                        result:
                                   [
                                     {
                                       'id'   => 'id_2',
                                       'name' => 'name_2'
                                     }
                                   ]
                      },
              id_only:
                      {
                        data:
                                   [
                                     {
                                       id:   'id_1',
                                       name: 'name_1'
                                     },
                                     {
                                       id:   'id_2',
                                       name: 'name_2'
                                     }
                                   ],
                        condition: '$.[*].id',
                        result:    %w(id_1 id_2)
                      },
              id_select:
                      {
                        data:
                                   [
                                     {
                                       id:   'id_1',
                                       name: 'name_1'
                                     },
                                     {
                                       id:   'id_2',
                                       name: 'name_2'
                                     }
                                   ],
                        condition: '$.[?(@.id=="id_2")]',
                        result:
                                   [
                                     {
                                       'id'   => 'id_2',
                                       'name' => 'name_2'
                                     }
                                   ]
                      }
            )

            def test_filter(data)
              assert_equal(@target.filter(data[:data], data[:condition]), data[:result])
            end

            data(
              none:   {
                data:      nil,
                condition: '$'
              },
              str:    {
                data:      '',
                condition: '$'
              },
              number: {
                data:      12_345,
                condition: '$',
                result:    12_345
              },
              true:   {
                data:      true,
                condition: '$',
                result:    true
              },
              false:  {
                data:      false,
                condition: '$',
                result:    false
              }
            )

            def test_filter_error(data)
              assert_throw(:done) do
                begin
                  @target.filter(data[:data], data[:condition])
                rescue
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
