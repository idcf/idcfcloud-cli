module Idcf
  module Cli
    module Conf
      # const
      class Const
        dir_path           = File.dirname(__FILE__)
        BASE_PATH          = File.expand_path("#{dir_path}/../../../")
        LOCAL_ERROR_PREFIX = '[idcfcli]'.freeze
        HEADERS            = {
          'User-Agent': "IDCF CLI v#{Idcf::Cli::VERSION}"
        }.freeze
        VALIDATOR_DIR_PATH = 'idcf/cli/validate/define'.freeze
        CODE_CONF_PATH     = "#{BASE_PATH}/idcf/cli/conf/conf.yml".freeze
        USER_CONF_PATH     = '~/.idcfcloud/config.ini'.freeze
        USER_CONF_GLOBAL   = "#{BASE_PATH}/../config/config.ini".freeze
        REGIONS            = %w(jp-east jp-east-2 jp-west).freeze
        USER_CONF_ITEMS    = {
          api_key:    nil,
          secret_key: nil,
          region:     REGIONS
        }.freeze
        CMD_FILE_DIR       = "#{BASE_PATH}/idcf/cli/conf/service".freeze
        CMD_FILE_EXT       = 'yml'.freeze
        SERVICE_PATH       = 'idcf/cli/service'.freeze
        TEMPLATE_DIR       = "#{BASE_PATH}/idcf/cli/templates".freeze
        OUT_DIR            = "#{BASE_PATH}/../output".freeze
        COMP_NOTIFICATION  = <<EOT.freeze
please write in
~/.bash_profile
source %s
~/.zprofile
source %s
EOT
      end
    end
  end
end
