require 'test/unit'
require 'idcf/cli/lib/convert/filter/show_filter'

module Idcf
  module Cli
    module Lib
      module Convert
        module Filter
          # test json path filter
          class TestShowFilter < Test::Unit::TestCase
            @target = nil

            def setup
              @target = ShowFilter.new
            end

            def cleanup
              @target = nil
            end

            COMMON_RESULT = {
              none:
                {
                  data:      nil,
                  condition: '',
                  result:    nil
                },
              str:
                {
                  data:      'data_str',
                  condition: '',
                  result:    'data_str'
                },
              number:
                {
                  data:      12_345,
                  condition: '',
                  result:    12_345
                },
              true:
                {
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
                  result:    []
                },
              empty_hash:
                {
                  data:      {},
                  condition: '',
                  result:    {}
                },
              hashs:
                {
                  data:
                             [
                               {
                                 'id'   => 'id_1',
                                 'name' => 'name_1',
                                 'hoge' => 'hoge_1'
                               },
                               {
                                 'id'   => 'id_2',
                                 'name' => 'name_2',
                                 'hoge' => 'hoge_2'
                               }
                             ],
                  condition: 'id,hoge',
                  result:
                             [
                               {
                                 'id'   => 'id_1',
                                 'hoge' => 'hoge_1'
                               },
                               {
                                 'id'   => 'id_2',
                                 'hoge' => 'hoge_2'
                               }
                             ]
                },
              nest_hashs:
                {
                  data:
                             [
                               [
                                 {
                                   'id'   => 'id_1-1',
                                   'name' => 'name_1-1',
                                   'hoge' => 'hoge_1-1'
                                 },
                                 {
                                   'id'   => 'id_1-2',
                                   'name' => 'name_1-2',
                                   'hoge' => 'hoge_1-2'
                                 }
                               ],
                               [
                                 {
                                   'id'   => 'id_2-1',
                                   'name' => 'name_2-1',
                                   'hoge' => 'hoge_2-1'
                                 },
                                 {
                                   'id'   => 'id_2-2',
                                   'name' => 'name_2-2',
                                   'hoge' => 'hoge_2-2'
                                 }
                               ]
                             ],
                  condition: 'id,hoge',
                  result:
                             [
                               [
                                 {
                                   'id'   => 'id_1-1',
                                   'hoge' => 'hoge_1-1'
                                 },
                                 {
                                   'id'   => 'id_1-2',
                                   'hoge' => 'hoge_1-2'
                                 }
                               ],
                               [
                                 {
                                   'id'   => 'id_2-1',
                                   'hoge' => 'hoge_2-1'
                                 },
                                 {
                                   'id'   => 'id_2-2',
                                   'hoge' => 'hoge_2-2'
                                 }
                               ]
                             ]
                }
            }.freeze

            filter_data            = COMMON_RESULT.deep_dup
            filter_data[:nest_str] = {
              data:
                         [
                           {
                             'id'            => 'id_1-1',
                             'name'          => 'name_1-1',
                             'hoge'          => 'hoge_1-1',
                             'hash'          => {
                               'id'   => 'id_1-1-1',
                               'hoge' => 'hoge_1-1-1'
                             },
                             'array'         => %w(1 2),
                             'array_in_hash' => [
                               {
                                 'str' => 'test_str_1-1-1',
                                 'num' => 'test_num_1-1-1'
                               },
                               {
                                 'str' => 'test_str_1-1-2',
                                 'num' => 'test_num_1-1-2'
                               }
                             ]
                           },
                           {
                             'id'            => 'id_1-2',
                             'name'          => 'name_1-2',
                             'hoge'          => 'hoge_1-2',
                             'hash'          => {
                               'id'   => 'id_1-2-1',
                               'hoge' => 'hoge_1-2-1'
                             },
                             'array'         => %w(1 2),
                             'array_in_hash' => [
                               {
                                 'str' => 'test_str_1-2-1',
                                 'num' => 'test_num_1-2-1'
                               },
                               {
                                 'str' => 'test_str_1-2-2',
                                 'num' => 'test_num_1-2-2'
                               }
                             ]
                           }
                         ],
              condition: 'id,hash,array,array_in_hash',
              result:
                         [
                           {
                             'id'            => 'id_1-1',
                             'hash'          => {
                               'id'   => 'id_1-1-1',
                               'hoge' => 'hoge_1-1-1'
                             },
                             'array'         => %w(1 2),
                             'array_in_hash' => [
                               {
                                 'str' => 'test_str_1-1-1',
                                 'num' => 'test_num_1-1-1'
                               },
                               {
                                 'str' => 'test_str_1-1-2',
                                 'num' => 'test_num_1-1-2'
                               }
                             ]
                           },
                           {
                             'id'            => 'id_1-2',
                             'hash'          => {
                               'id'   => 'id_1-2-1',
                               'hoge' => 'hoge_1-2-1'
                             },
                             'array'         => %w(1 2),
                             'array_in_hash' => [
                               {
                                 'str' => 'test_str_1-2-1',
                                 'num' => 'test_num_1-2-1'
                               },
                               {
                                 'str' => 'test_str_1-2-2',
                                 'num' => 'test_num_1-2-2'
                               }
                             ]
                           }
                         ]
            }

            data(
              filter_data.deep_dup
            )

            def test_filter_no_table(data)
              obj = ShowFilter.new(table_flag: false)
              assert_equal(obj.filter(data[:data], data[:condition]), data[:result])
            end

            filter_data[:nest_str][:result] =
              [
                {
                  'id'            => 'id_1-1',
                  'hash'          => {
                    'id'   => 'id_1-1-1',
                    'hoge' => 'hoge_1-1-1'
                  }.to_s,
                  'array'         => %w(1 2).to_s,
                  'array_in_hash' => [
                    {
                      'str' => 'test_str_1-1-1',
                      'num' => 'test_num_1-1-1'
                    },
                    {
                      'str' => 'test_str_1-1-2',
                      'num' => 'test_num_1-1-2'
                    }
                  ].to_s
                },
                {
                  'id'            => 'id_1-2',
                  'hash'          => {
                    'id'   => 'id_1-2-1',
                    'hoge' => 'hoge_1-2-1'
                  }.to_s,
                  'array'         => %w(1 2).to_s,
                  'array_in_hash' => [
                    {
                      'str' => 'test_str_1-2-1',
                      'num' => 'test_num_1-2-1'
                    },
                    {
                      'str' => 'test_str_1-2-2',
                      'num' => 'test_num_1-2-2'
                    }
                  ].to_s
                }
              ]

            data(
              filter_data.deep_dup
            )

            def test_filter_table(data)
              obj = ShowFilter.new(table_flag: true)
              assert_equal(obj.filter(data[:data], data[:condition]), data[:result])
            end

            data(
              none:   {
                data:      nil,
                condition: '$'
              },
              str:    {
                data:      'data_str',
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
