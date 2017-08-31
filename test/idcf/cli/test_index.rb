require 'test/unit'
require 'idcf/cli/index'
require 'idcf/cli/conf/const'
require 'date'

module Idcf
  module Cli
    class TestIndex < Test::Unit::TestCase
      @target = nil

      def setup
        Idcf::Cli::Index.init
        @target = Idcf::Cli::Index.new
      end

      def cleanup
        @target = nil
      end

      def file_timestamps
        dir = Idcf::Cli::Conf::Const::CMD_FILE_DIR
        ext = Idcf::Cli::Conf::Const::CMD_FILE_EXT
        result = {}
        Dir.glob("#{dir}/*.#{ext}").each do |f|
          fn = File.basename(f, ".#{ext}")
          result[fn] = File.mtime(f)
        end

        path = Idcf::Cli::Conf::Const::OUT_DIR
        Dir.glob("#{path}/*").each do |f|
          fn = File.basename(f, '.*')
          result[fn] = File.mtime(f)
        end
        result
      end

      data(
        update: {}
      )

      def test_update(_data)
        b_info = file_timestamps
        @target.send(:update)
        a_info = file_timestamps
        assert_not_equal(b_info, a_info)
      end
    end
  end
end
