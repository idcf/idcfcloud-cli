require 'idcf/cli/lib/configure'
module Idcf
  module Cli
    module Controller
      module Extend
        # util
        module Util
          # get region
          #
          # @param o [Hash] options
          # @param read_conf [Boolean]
          # @return String
          def get_region(o)
            flg = !class_options[:region].nil?
            Idcf::Cli::Lib::Configure.get_region(o, flg)
          end

          # make schema path
          #
          # @param o [Hash]
          # @return String
          def make_schema_path(o)
            fn     = name.underscore.split('/').pop
            dir    = Idcf::Cli::Conf::Const::CMD_FILE_DIR
            ext    = Idcf::Cli::Conf::Const::CMD_FILE_EXT
            region = get_region(o)
            v      = service_version(o)
            "#{dir}/#{fn}_#{v}_#{region}.#{ext}"
          end
        end
      end
    end
  end
end
