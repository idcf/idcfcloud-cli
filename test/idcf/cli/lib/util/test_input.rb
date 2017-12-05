require 'test/unit'
require 'idcf/cli/conf/const'
require 'thor'
require 'idcf/cli/lib/util/input'

module Idcf
  module Cli
    module Lib
      module Util
        # test input
        class TestInput < Test::Unit::TestCase
          @target = nil

          def setup
            @target = Idcf::Cli::Lib::Util::Input
          end

          def cleanup
            @target = nil
          end

          data(
            match:     {
              list: %w(aaa aba),
              data: 'aaa'
            },
            match2:    {
              list: %w(aaa aba),
              data: 'aba'
            },
            none_list: {
              list: %w(),
              data: 'aaa'
            },
            all_none:  {
              list: %w(),
              data: ''
            }
          )

          def test_qa_answer?(data)
            result = @target.send(:qa_answer?, data[:data], data[:list])
            assert(result)
          end

          data(
            front:     {
              list: %w(aaa aba),
              data: 'ab'
            },
            back:      {
              list: %w(aaa aba),
              data: 'ba'
            },
            none_list: {
              list: %w(aaa bbb),
              data: ''
            }
          )

          def test_no_match_qa_answer?(data)
            result = @target.send(:qa_answer?, data[:data], data[:list])
            refute(result)
          end
        end
      end
    end
  end
end
