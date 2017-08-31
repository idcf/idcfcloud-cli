require 'idcf/cli/conf/const'
require 'idcf/cli/lib/util/ini_conf'

module Idcf
  module Cli
    module Extend
      # configure settings
      module Configure
        protected

        def do_configure(o)
          path     = configure_path(o)
          config   = Idcf::Cli::Lib::Util::IniConf.new(path)
          profiles = []
          if o[:profile] != 'default' && !check_profile?(config, 'default')
            profiles << 'default'
          end
          profiles << o[:profile]
          config = configure_input(config, profiles)
          config.write(path)
        end

        def configure_path(o)
          cls    = Idcf::Cli::Conf::Const
          result = o[:global] ? cls::USER_CONF_GLOBAL : cls::USER_CONF_PATH
          File.expand_path(result)
        end

        def check_profile?(config, name)
          conf = config[name]
          return false if conf.nil?
          Idcf::Cli::Conf::Const::USER_CONF_ITEMS.each do |k, _v|
            return false if conf[k.to_s].strip.empty?
          end

          true
        end

        def configure_input(config, profiles)
          profiles.each do |profile|
            dt = config[profile] || {}
            Idcf::Cli::Conf::Const::USER_CONF_ITEMS.each do |k, v|
              nd         = dt[k.to_s].nil? ? '' : dt[k.to_s]
              msg        = "#{profile}:#{k}[#{nd.empty? ? 'NONE' : nd}] : "
              dt[k.to_s] = configure_qa_dialog(msg, nd, v)
            end
            config[profile] = dt
          end
          config
        end

        def configure_qa_dialog(msg, nd, setting)
          loop do
            puts msg
            res = STDIN.gets.strip
            next unless !res.empty? || !nd.empty?
            result = res.empty? ? nd : res
            return result if confirmation_at_qa_preference?(result, setting)
            puts "from this [#{setting.join('/')}]"
          end
        end

        def confirmation_at_qa_preference?(val, setting)
          return true if setting.nil?
          return true if Regexp.new("\\A(#{setting.join('|')})\\Z") =~ val
          false
        end
      end
    end
  end
end
