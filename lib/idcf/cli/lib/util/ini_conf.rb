require 'inifile'
require 'fileutils'
module Idcf
  module Cli
    module Lib
      module Util
        # ini conf
        class IniConf
          attr_reader :load_data, :tmp_data

          # initialize
          #
          # @param path [String] ini file path
          def initialize(*path)
            @tmp_data  = {}
            @load_data = IniFile.load(path[0])
          end

          def load_error?
            @load_data.nil?
          end

          def [](profile)
            return nil if load_error?
            @load_data[profile.to_s]
          end

          def []=(profile, value)
            data               = load_error? ? @tmp_data : @load_data
            data[profile.to_s] = value
          end

          # get config value
          #
          # @param name [String]
          # @param profile [String]
          # @return String or Hash
          # @raise
          def find(name, profile)
            begin
              @load_data[profile].fetch(name)
            rescue
              @load_data['default'].fetch(name)
            end
          rescue
            msg = "Error: could not read #{profile}:#{name}"
            raise Idcf::Cli::CliError, msg
          end

          def write(path)
            unless File.exist?(path)
              dir_path = File.dirname(path)
              FileUtils.mkdir_p(dir_path) unless Dir.exist?(dir_path)
              File.open(path, 'w').close
              @load_data = IniFile.load(path)
            end

            @tmp_data.each do |k, v|
              @load_data[k] = v
            end
            @load_data.write(filename: path)
          end
        end
      end
    end
  end
end
