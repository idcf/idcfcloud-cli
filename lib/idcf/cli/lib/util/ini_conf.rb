require 'inifile'
require 'fileutils'
module Idcf
  module Cli
    module Lib
      module Util
        # ini conf
        class IniConf
          attr_reader :load_data, :tmp_data, :read_only

          # initialize
          #
          # @param path [String] ini file path
          def initialize(*path)
            @tmp_data  = {}
            @load_data = IniFile.load(path[0])
            @read_only = false
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
            rescue StandardError => _e
              @load_data['default'].fetch(name)
            end
          rescue StandardError => _e
            msg = "Error: could not read #{profile}:#{name}"
            raise Idcf::Cli::Error::CliError, msg
          end

          # write
          #
          # @param path [String]
          def write(path)
            raise Idcf::Cli::Error::CliError, 'read only object' if @read_only
            @load_data = load_create_file(path) unless File.exist?(path)

            @tmp_data.each do |k, v|
              @load_data[k] = v
            end
            @load_data.write(filename: path)
          end

          # inifile object merge
          #
          # @param value [Idcf::Cli::Lib::Util::IniConf]
          # @return self
          def merge!(value)
            raise Idcf::Cli::Error::CliError, 'merge error' unless value.class == self.class
            v_data = value.load_data
            return self if v_data.nil?
            @load_data.merge!(v_data)
            @read_only = true
            self
          end

          protected

          def load_create_file(path)
            dir_path = File.dirname(path)
            FileUtils.mkdir_p(dir_path) unless Dir.exist?(dir_path)
            File.open(path, 'w').close
            IniFile.load(path)
          end
        end
      end
    end
  end
end
