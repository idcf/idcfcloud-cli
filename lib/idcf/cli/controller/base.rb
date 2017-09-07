require 'thor'
require 'json'
require 'active_support'
require 'active_support/core_ext'
require 'idcf/cli/conf/const'
require 'idcf/cli/lib/util/ini_conf'
require 'idcf/cli/lib/util/yml_conf'
require 'idcf/cli/lib/convert/helper'
require_relative './extend/init'
require_relative './include/init'

module Idcf
  module Cli
    module Controller
      # Controller Base
      class Base < Thor
        class_option :output,
                     type:    :string,
                     aliases: '-o',
                     desc:    'output type: table/json/xml/csv'
        class_option :profile,
                     type: :string,
                     desc: 'use profile'
        class_option :api_key,
                     type: :string,
                     desc: 'api key'
        class_option :secret_key,
                     type: :string,
                     desc: 'secret key'
        class_option :no_ssl,
                     desc: 'not use ssl'
        class_option :no_vssl,
                     desc: 'not use verify ssl'

        attr_reader :config, :code_conf, :cmd, :m_classes

        extend Idcf::Cli::Controller::Extend::Init
        include Idcf::Cli::Controller::Include::Init

        class << self
          def init
            fn   = to_s.underscore.split('/').pop
            dir  = Idcf::Cli::Conf::Const::CMD_FILE_DIR
            ext  = Idcf::Cli::Conf::Const::CMD_FILE_EXT
            path = "#{dir}/#{fn}.#{ext}"

            if File.exist?(path)
              cf = Idcf::Cli::Lib::Util::YmlConf.new(path)
              register_sdk_method! cf.find('')
            end

            register_service_method!
          end

          # regist method
          #
          # @param methods [Hash]
          def register_sdk_method!(methods)
            return unless methods
            methods.each do |command, s|
              register_method!(command, s[:params], s[:options])
            end
          end

          # regist service method
          def register_service_method!
            make_module_classes.each do |cn, c|
              register_method!(cn, c.params, c.options)
            end
          end
        end

        protected

        def execute(cmd, *args)
          data = run(cmd, args)
          puts make_result_str(data, false, options)
        rescue => e
          STDERR.puts e.message
          exit 1
        end

        def run(cmd, args)
          @cmd = cmd
          check_params(self.class.make_module_classes, cmd, *args)
          o    = options
          data = do_validate(o)
          if data
            STDERR.puts data[:message].flatten
            exit 1
          end
          data = make_result_data(do_command(cmd, *args, o), o)
          data
        end

        def do_command(cmd, *args, o)
          m_class = self.class.search_module_class(cmd)

          arg    = convert_arg_json(*args)
          client = make_client(o)
          return m_class.new.do(client, *arg, o) unless m_class.nil?
          do_sdk(client, cmd, *arg, o)
        end

        # make response base data
        #
        # @return Hash
        def make_base_response
          {
            status:  200,
            message: '',
            data:    []
          }
        end

        # make error result
        #
        # @param error [Exception]
        # @return Hash
        def make_error(error)
          error.to_s =~ /status code: ?(\d+)/
          match            = Regexp.last_match(1)
          result           = make_base_response
          result[:status]  = match ? match.to_i : 400
          result[:message] = error.message
          result
        end

        def make_result_data(data, o)
          result = data
          format = output_format(o, '')
          if format == 'csv' || format == 'table'
            result = make_table_data(data)
          else
            result        = make_base_response
            result[:data] = data
          end
          result
        end

        # table data
        # @param data [Hash]
        # @return Hash
        def make_table_data(data)
          data
        end
      end
    end
  end
end
