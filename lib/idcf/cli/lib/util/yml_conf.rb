require 'yaml'
module Idcf
  module Cli
    module Lib
      module Util
        # yml conf
        class YmlConf
          @load_data = nil

          # initialize
          #
          # @param path [String] yml file path
          def initialize(*path)
            @load_data = YAML.load_file(path[0])
          end

          # get config value
          #
          # @param path [String]
          # @return String or Hash
          # @raise
          def find(path)
            result = @load_data
            return result[path] if path.class == Symbol
            path.split('.').each do |name|
              result = result.fetch(name)
            end

            result
          rescue
            raise Idcf::Cli::CliError, "Error: could not read '#{path}'"
          end
        end
      end
    end
  end
end
