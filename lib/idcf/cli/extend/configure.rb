require 'idcf/cli/conf/const'
require 'idcf/cli/lib/util/ini_conf'

module Idcf
  module Cli
    module Extend
      # configure settings
      module Configure
        protected

        # configure settings
        #
        # @param o [Hash]
        # @param init_f [Boolean]
        def do_configure(o, init_f = false)
          path     = configure_path(o)
          config   = Idcf::Cli::Lib::Util::IniConf.new(path)
          profiles = make_profiles(config, o)
          cls      = Idcf::Cli::Conf::Const
          prefix   = o[:global] ? 'global' : 'local'
          configure_input(config, profiles, cls::USER_CONF_ITEMS, prefix).write(path)

          global_setting if init_f
        end

        def make_profiles(config, o)
          [].tap do |result|
            result << 'default' if o[:profile] != 'default' && !check_profile?(config, 'default')
            result << o[:profile]
          end
        end

        def check_profile?(config, name)
          conf = config[name]
          return false if conf.nil?
          Idcf::Cli::Conf::Const::USER_CONF_ITEMS.each_key do |k|
            return false if conf[k.to_s].strip.empty?
          end
          true
        end

        def global_setting
          cls    = Idcf::Cli::Conf::Const
          path   = cls::USER_CONF_GLOBAL
          config = Idcf::Cli::Lib::Util::IniConf.new(File.expand_path(path))
          configure_input(config, ['default'], cls::GLOBAL_CONF_ITEMS).write(path)
        end

        def configure_path(o)
          cls    = Idcf::Cli::Conf::Const
          result = o[:global] ? cls::USER_CONF_GLOBAL : cls::USER_CONF_PATH
          File.expand_path(result)
        end

        def configure_input(config, profiles, items, prefix = 'global')
          profiles.each do |profile|
            dt = config[profile] || {}
            items.each do |k, v|
              key_s     = k.to_s
              nd        = dt[key_s].nil? ? setting_extraction(v, :default).to_s : dt[key_s]
              dt[key_s] = Idcf::Cli::Lib::Util::Input.qa("#{prefix}[#{profile}]:#{k}", v, nd)
            end
            config[profile] = dt
          end
          config
        end

        def setting_extraction(setting, key)
          setting.class == Hash ? setting[key] : nil
        end
      end
    end
  end
end
