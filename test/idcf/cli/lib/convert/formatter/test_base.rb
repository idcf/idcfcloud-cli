require 'test/unit'

module Idcf
  module Cli
    module Lib
      module Convert
        module Formatter
          # test base
          class TestBase < Test::Unit::TestCase
            ERROR_NO_DATA_ARRAY = {
              status: 400,
              message: %w(msg msg2),
              data: []
            }.freeze
            ERROR_NO_DATA_HASH = {
              status: 400,
              message: %w(msg msg2),
              data: {}
            }.freeze
            ERROR_EXIST_DATA = {
              status: 400,
              message: %w(msg msg2),
              data: [1, 2]
            }.freeze
            FORMAT_VALIDATE_ERROR = {
              status: 400,
              message: {
                v1: ['v1 error'],
                v2: ['v2 error']
              },
              data: []
            }.freeze
            FORMAT_SUCCESS_NONE_ARRAY = {
              status: 200,
              message: [],
              data: []
            }.freeze
            FORMAT_SUCCESS_NONE_HASH = {
              status: 200,
              message: [],
              data: {}
            }.freeze
            FORMAT_SUCCESS_FLAT_ARRAY_NUM = {
              status: 200,
              message: [],
              data: [10, 20, 30, 40]
            }.freeze
            FORMAT_SUCCESS_FLAT_ARRAY_STR = {
              status: 200,
              message: [],
              data: %w(10 20 30 40)
            }.freeze
            FORMAT_SUCCESS_ONE_DATA = {
              status: 200,
              message: [],
              data: [
                {
                  id: '1-0-1',
                  txt: '1-0-1 sample',
                  conf: { id: '1-1-1', txt: '1-1 sample' },
                  list: [
                    { id: '1-2-1', txt: '2-1 sample' },
                    { id: '1-2-2', txt: '2-2 sample' }
                  ]
                }
              ]
            }.freeze
            FORMAT_SUCCESS_MULTI_DATA = {
              status: 200,
              message: [],
              data: [
                {
                  id: '1-0-1',
                  txt: '1-0-1 sample',
                  conf: { id: '1-1-1', txt: '1-1 sample' },
                  list: [
                    { id: '1-2-1', txt: '2-1 sample' },
                    { id: '1-2-2', txt: '2-2 sample' }
                  ]
                },
                {
                  id: '2-0-1',
                  txt: '2-0-1 sample',
                  conf: { id: '2-1-1', txt: '1-1 sample' },
                  list: [
                    { id: '2-2-1', txt: '2-1 sample' },
                    { id: '2-2-2', txt: '2-2 sample' }
                  ]
                }
              ]
            }.freeze
          end
        end
      end
    end
  end
end
