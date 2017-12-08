require 'idcf/cli/conf/const'
require 'idcf/cli/lib/util/ini_conf'
require 'idcf/cli/lib/util/yml_conf'

module Idcf
  module Cli
    module Lib
      # configure
      class Configure
        class << self
          attr_reader :config, :code_config

          def reload
            @config      = nil
            @code_config = nil
          end

          # get user config value
          #
          # @param name [String]
          # @param profile [String]
          # @return String or Hash
          # @raise
          def get_user_conf(name, profile = 'default')
            return config.find(name, profile) if config
            @config = load_user_conf
            msg     = 'Run the command `configure`'
            raise Idcf::Cli::Error::CliError, msg unless config

            config.find(name, profile)
          end

          # get code setting value
          #
          # @param path [String] find path
          # @param o [Hash] options
          # @return String or Hash
          # @raise
          def get_code_conf(path, o = {})
            profile = get_profile(o)

            return get_user_conf(path, profile)
          rescue
            return code_config.find(path) if code_config
            f_path       = Idcf::Cli::Conf::Const::CODE_CONF_PATH
            @code_config = Idcf::Cli::Lib::Util::YmlConf.new(f_path)
            code_config.find(path)
          end

          # get profile
          #
          # @param o [Hash] options
          # @return String
          def get_profile(o)
            o['profile'] || 'default'
          end

          # get region
          #
          # @param o [Hash] options
          # @param read_conf [Boolean]
          # @return String
          def get_region(o, read_conf = false)
            return o['region'] if o['region']
            region = ''
            region = get_user_conf('region', get_profile(o)) if read_conf
            region.empty? ? 'default' : region
          rescue
            'default'
          end

          protected

          # load user config
          # read only object
          #
          # @return Idcf::Cli::Lib::Util::IniConf
          def load_user_conf
            result = nil
            [
              Idcf::Cli::Conf::Const::USER_CONF_GLOBAL,
              Idcf::Cli::Conf::Const::USER_CONF_PATH
            ].each do |v|
              tmp = Idcf::Cli::Lib::Util::IniConf.new(File.expand_path(v))
              next if tmp.load_error?
              result = result.nil? ? tmp : result.merge!(tmp)
            end
            result
          end
        end
      end
    end
  end
end
