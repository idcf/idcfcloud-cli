require 'logger'
require 'idcf/cli/version'
module Idcf
  module Cli
    module Conf
      # const
      class Const
        DOCUMENT_URL              = 'https://www.idcf.jp/api-docs/apis/'.freeze
        DOCUMENT_ID_SEP           = '_'.freeze
        DOCUMENT_SPACE_CONVERSION = '-'.freeze
        DOCUMENT_ID_PREFIX_FORMAT = 'docs_%<service>s_reference%<version>s'.freeze
        VERSION_STR               = "idcfcloud version #{Idcf::Cli::VERSION}".freeze
        now                       = Time.now.strftime('%Y%m%d%H%M%S%6N')
        dir_path                  = File.dirname(__FILE__)
        BASE_PATH                 = File.expand_path("#{dir_path}/../../../")
        LOCAL_ERROR_PREFIX        = '[idcfcli]'.freeze
        HEADERS                   =
          {
            'User-Agent': "IDCF CLI v#{Idcf::Cli::VERSION}"
          }.freeze
        USER_DIR_PATH             = '~/.idcfcloud'.freeze
        VALIDATOR_DIR_PATH        = 'idcf/cli/validate/define'.freeze
        CODE_CONF_PATH            = "#{BASE_PATH}/idcf/cli/conf/conf.yml".freeze
        USER_CONF_PATH            = "#{USER_DIR_PATH}/config.ini".freeze
        USER_CONF_GLOBAL          = "#{BASE_PATH}/../config/config.ini".freeze
        REGIONS                   = %w[jp-east jp-east-2 jp-west].freeze
        GLOBAL_CONF_ITEMS         =
          {
            output_log: {
              default: 'Y',
              list:    %w[Y n]
            },
            log_path:   {
              default: '~/.idcfcloud/log'
            }
          }.freeze
        USER_CONF_ITEMS           =
          {
            api_key:    nil,
            secret_key: nil,
            region:     {
              list: REGIONS
            }
          }.freeze
        FULL_HREF_REGEXP          = Regexp.new('\A[a-zA-Z]*:?//').freeze
        CMD_FILE_DIR              = "#{BASE_PATH}/idcf/cli/conf/service".freeze
        CMD_FILE_EXT              = 'json'.freeze
        SERVICE_PATH              = 'idcf/cli/service'.freeze
        TEMPLATE_DIR              = "#{BASE_PATH}/idcf/cli/templates".freeze
        OUT_DIR                   = "#{BASE_PATH}/../output".freeze
        COMP_PATHS                = {
          bash: '~/.bash_profile',
          zsh:  '~/.zprofile'
        }.freeze
        LOG_FILE_PREFIX           = 'cli_log_'.freeze
        LOG_FILE_NAME             = "#{LOG_FILE_PREFIX}#{now}.log".freeze
        LOG_LEVEL                 = Logger::INFO.freeze
        CLASSIFY_RULE             = [
          %w[sslalgorithms_ids SslalgorithmsIds],
          %w[dns Dns]
        ].freeze
      end
    end
  end
end
