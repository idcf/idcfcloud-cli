module Idcf
  module Cli
    module Controller
      module Include
        # util
        module Util
          protected

          # get user config value
          #
          # @param name [String]
          # @param profile [String]
          # @return String or Hash
          # @raise
          def get_user_conf(name, profile = 'default')
            return @config.find(name, profile) if @config
            @config = make_user_conf
            msg     = 'Run the command `configure`'
            raise Idcf::Cli::CliError, msg unless @config

            @config.find(name, profile)
          end

          def make_user_conf
            [
              Idcf::Cli::Conf::Const::USER_CONF_PATH,
              Idcf::Cli::Conf::Const::USER_CONF_GLOBAL
            ].each do |v|
              result = Idcf::Cli::Lib::Util::IniConf.new(v)
              return result unless result.load_error?
            end
            nil
          end

          # get code setting value
          #
          # @param path [String]
          # @return String or Hash
          # @raise
          def get_code_conf(path, o)
            profile = get_profile(o)

            return get_user_conf(path, profile)
          rescue
            return @code_conf.find(path) if @code_conf
            f_path     = Idcf::Cli::Conf::Const::CODE_CONF_PATH
            @code_conf = Idcf::Cli::Lib::Util::YmlConf.new(f_path)
            @code_conf.find(path)
          end

          # get profile
          #
          # @param o [Hash] options
          # @return String
          def get_profile(o)
            o[:profile] || 'default'
          end

          # get region
          #
          # @param o [Hash] options
          # @return String
          def get_region(o)
            return o[:region] if o[:region]
            region = get_user_conf('region')
            region.empty? ? 'default' : region
          rescue
            'default'
          end

          # make result string
          #
          # @param data [Hash]
          # @param err_f [Boolean]
          # @param o [Hash]
          # @return Stirng
          def make_result_str(data, err_f, o)
            message = data.class == Hash ? data[:message] : {}
            f       = output_format(o, message)
            Idcf::Cli::Lib::Convert::Helper.new.format(data, err_f, f)
          end

          # output format
          #
          # @param o [Hash] options
          # @param message [Hash] Validate Hash
          # @return String
          def output_format(o, message)
            default_output = get_code_conf('output', o)
            if message.class == Hash && !message[:output].nil?
              return default_output
            end

            f = o[:output]
            f.nil? ? default_output : f
          end
        end
      end
    end
  end
end
