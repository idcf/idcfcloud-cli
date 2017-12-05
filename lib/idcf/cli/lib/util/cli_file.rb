module Idcf
  module Cli
    module Lib
      module Util
        # cli file
        class CliFile
          class << self
            # mkdir
            #
            # @param path [String]
            # @raise
            def mkdir(path)
              target = file?(path) ? File.dirname(path) : path
              FileUtils.mkdir_p(target, mode: 0o755)
            rescue => e
              raise Idcf::Cli::Error::CliError, e.message
            end

            # writable
            #
            # @param path [String]
            # @raise
            def writable(path)
              msg = "Permission error (#{path})"
              raise Idcf::Cli::Error::CliError, msg unless File.writable?(path)
            end

            protected

            def file?(path)
              return false if Dir.exist?(path)
              last_path = path.split('/').pop
              last_path.split('.').size > 1
            end
          end
        end
      end
    end
  end
end
