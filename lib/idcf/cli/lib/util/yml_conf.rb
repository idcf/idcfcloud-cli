require 'yaml'
module Idcf
  module Cli
    module Lib
      module Util
        # yml conf
        class YmlConf
          attr_reader :load_data

          class << self
            attr_reader :data
            def load(path)
              @data ||= {}
              return @data[path] unless @data[path].nil?
              @data[path] = name.constantize.new(path)
              @data[path]
            end
          end

          # initialize
          #
          # @param path [String] yml file path
          def initialize(*path)
            @load_data = YAML.load_file(path[0])
          end

          # get config value
          #
          # @param path [String]
          # @param section [String]
          # @return String or Hash
          # @raise
          def find(path)
            result = @load_data
            return result[path] if path.class == Symbol
            path.split('.').each do |name|
              result = result.fetch(name)
            end

            result
          rescue StandardError => _e
            raise Idcf::Cli::Error::CliError, "Error: could not read '#{path}'"
          end
        end
      end
    end
  end
end
