require 'fileutils'
require 'idcf/cli/conf/const'

module Idcf
  module Cli
    module Extend
      # update file
      module UpdateFile
        protected

        def writable_setting_file(services)
          b_dir = File.expand_path(Idcf::Cli::Conf::Const::CMD_FILE_DIR)
          FileUtils.mkdir_p(b_dir) unless Dir.exist?(b_dir)
          writable?(File.dirname(b_dir))

          services.each do |v|
            path = "#{b_dir}/#{v}.#{Idcf::Cli::Conf::Const::CMD_FILE_EXT}"
            writable?(File.dirname(path)) if File.exist?(path)
          end
        end

        def output_yaml(s_name, data)
          dir  = Idcf::Cli::Conf::Const::CMD_FILE_DIR
          ext  = Idcf::Cli::Conf::Const::CMD_FILE_EXT
          path = "#{File.expand_path(dir)}/#{s_name}.#{ext}"
          write_file(path, data.to_yaml)
        end

        def output_complement_file(str, outpath)
          dir_path = File.dirname(outpath)
          unless Dir.exist?(dir_path)
            writable?(File.dirname(dir_path))
            Dir.mkdir(dir_path)
          end
          writable?(dir_path)

          write_file(outpath, str)
        end

        def write_file(path, str)
          File.open(path, 'w') do |f|
            f.puts(str)
          end
        end

        def writable?(path)
          msg = "Permission error (#{path})"
          raise Idcf::Cli::CliError, msg unless File.writable?(path)
        end
      end
    end
  end
end
